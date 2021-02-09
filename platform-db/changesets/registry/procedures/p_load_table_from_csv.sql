--liquibase formatted sql
/*
 * Copyright 2021 EPAM Systems.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    https://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
--changeset platform:p_load_table_from_csv splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE PROCEDURE p_load_table_from_csv(p_table_name text, p_file_name text, p_table_columns text[], p_target_table_columns text[] DEFAULT NULL::text[])
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  l_sql TEXT;
  l_sys_cols text := 'curr_user=>"admin",source_system=>"Initial load",source_application=>"Initial load",source_process=>"Initial load process",process_id=>"0000"';
  l_cols text := '';
  l_row record;
  l_target_table_columns text[] := coalesce(p_target_table_columns,p_table_columns);
  l_col_name TEXT;
  l_col_value TEXT;
  l_is_uuid BOOLEAN := FALSE;
  l_uuid TEXT := NULL;
  j INT := 0;
  l_ref refs;
  l_col_names TEXT[];
  l_col_vals TEXT[];
  l_curr_idx int;
  l_system_roles_arr text := 'array[null, null, null, null]::text[]'; -- system role marker to skip RBAC check during initial data load
BEGIN
  --
  FOR i IN array_lower(p_table_columns, 1)..array_upper(p_table_columns, 1) LOOP
    l_cols := l_cols || p_table_columns[i] || ' TEXT,';
    IF p_table_columns[i] = 'uuid' THEN
      l_is_uuid := TRUE;
    END IF;
  END LOOP;
  l_cols := TRIM(TRAILING ',' FROM l_cols);
  --
  l_sql := format($$DROP FOREIGN TABLE IF EXISTS %I_csv$$, p_table_name);
  execute l_sql;
  --
  l_sql := format($$CREATE FOREIGN TABLE %I_csv(%s) SERVER srv_file_fdw
                    OPTIONS (FILENAME '%s', FORMAT 'csv', HEADER 'true', DELIMITER ',', ENCODING 'UTF8' )$$, p_table_name, l_cols, p_file_name);
  CALL p_raise_notice(l_sql);
  execute l_sql;
  --
  l_cols := '';
  FOR i IN array_lower(l_target_table_columns, 1)..array_upper(l_target_table_columns, 1) LOOP
    --
    CASE WHEN split_part(l_target_table_columns[i],'::',2) = '' THEN
           l_col_name := split_part(l_target_table_columns[i],'::',1);
           l_col_value := l_col_name;
         WHEN split_part(l_target_table_columns[i],'::',2) LIKE 'ref(%' THEN
           l_col_name := split_part(l_target_table_columns[i],'::',1);
           l_ref := f_get_ref_record(l_target_table_columns[i]);
           l_col_value := format('(f_get_id_from_ref_table(''%s'',''%s'',''%s'',%s))', l_ref.ref_table, l_ref.ref_col, l_ref.ref_id, l_ref.lookup_col);
         WHEN split_part(l_target_table_columns[i],'::',2) LIKE 'ref_array(%' then
           NULL;
         ELSE
           l_col_name := split_part(l_target_table_columns[i],'::',1);
           l_col_value := split_part(l_target_table_columns[i],'::',2) ;
    END CASE;
    l_cols := l_cols ||''||l_col_name||'=>''||coalesce(''"''||REGEXP_REPLACE(trim('||l_col_value||', chr(160)),''"'',''\"'',''g'')||''"'',''NULL'')||'',' ;
    --
  END LOOP;
  --
  FOR i IN array_lower(l_target_table_columns, 1)..array_upper(l_target_table_columns, 1) LOOP
    CASE WHEN split_part(l_target_table_columns[i],'::',2) LIKE 'ref_array(%' then
           -- merge duplicated columns
           l_curr_idx := array_position(l_col_names, split_part(l_target_table_columns[i],'::',1));
           IF l_curr_idx IS NULL THEN
             l_col_names := array_append(l_col_names, split_part(l_target_table_columns[i],'::',1));
             l_col_vals  := array_append(l_col_vals, NULL);
             l_curr_idx  := array_position(l_col_names, split_part(l_target_table_columns[i],'::',1));
           END IF;
           l_ref := f_get_ref_record(l_target_table_columns[i]);
           l_col_vals[l_curr_idx] := concat_ws(',', l_col_vals[l_curr_idx], format('(f_get_id_from_ref_array_table(''%s'',''%s'',''%s'',%s,''%s''))', l_ref.ref_table, l_ref.ref_col, l_ref.ref_id, l_ref.lookup_col, l_ref.list_delim));
      ELSE
           NULL;
    END CASE;
  END LOOP;
  --
  IF array_length(l_col_names, 1) > 0 then
    FOR i IN array_lower(l_col_names, 1)..array_upper(l_col_names, 1) LOOP
      l_cols := l_cols ||''||l_col_names[i]||'=>''||coalesce(''"{''||REGEXP_REPLACE(trim(concat_ws('','','||l_col_vals[i]||'), chr(160)),''"'',''\"'',''g'')||''}"'',''NULL'')||'',' ;
    END LOOP;
  END IF;
  --
  l_cols := TRIM(TRAILING ',' FROM l_cols);
  CALL p_raise_notice(l_cols);
  --
  IF l_is_uuid THEN
--    l_sql := format('SELECT ''($$%s$$)::hstore);'' f FROM %I_csv', l_cols, p_table_name);
    l_sql := format('SELECT ''SELECT f_row_insert(''''%I'''', (''''%s'''')::hstore,($$%s$$)::hstore, ' || l_system_roles_arr || ', ''''''||uuid||''''''::uuid);'' f
                 FROM %I_csv'
                 , p_table_name, l_sys_cols, l_cols, p_table_name);
--                 , array_to_string(l_lookups,', '), p_table_name, l_sys_cols, l_cols, p_table_name);
  ELSE
    l_sql := format('SELECT ''SELECT f_row_insert(''''%I'''', (''''%s'''')::hstore,($$%s$$)::hstore, ' || l_system_roles_arr || ');'' f
                 FROM %I_csv'
                 , p_table_name, l_sys_cols, l_cols, p_table_name);
  END IF;
  CALL p_raise_notice(l_sql);
  --
  FOR l_row IN EXECUTE l_sql LOOP
    CALL p_raise_notice(l_row.f);
    EXECUTE l_row.f;
  END LOOP;
  --
  l_sql := format($$DROP FOREIGN TABLE IF EXISTS %I_csv$$, p_table_name);
  execute l_sql;
  --
END;
$procedure$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;
