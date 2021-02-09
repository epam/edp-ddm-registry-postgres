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
--changeset platform:f_row_insert splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE FUNCTION f_row_insert(p_table_name TEXT, p_sys_key_val hstore, p_business_key_val hstore, p_roles_arr TEXT[] DEFAULT NULL, p_uuid uuid DEFAULT uuid_generate_v4())
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
  l_key_name TEXT;
  c_history_suffix CONSTANT TEXT := '_hst';
  l_table_hst TEXT := p_table_name||c_history_suffix;
  l_table_rcnt TEXT := p_table_name;
  --
  lr_kv RECORD;
  l_id UUID := p_uuid;
  --
  l_cols_rcnt TEXT := '';
  l_vals_rcnt TEXT := '';
  l_sys_kv_rcnt hstore;
  --
  l_cols_hst TEXT := '';
  l_vals_hst TEXT := '';
  l_sys_kv_hst hstore;
  --
  l_sql_hst TEXT;
  l_sql_rcnt TEXT;
BEGIN
  -- check permissions
  IF NOT f_check_permissions(p_table_name, p_roles_arr, 'I') THEN
    RAISE EXCEPTION 'ERROR: Permission denied' USING ERRCODE = '20003';
  END IF;
  -- gets pkey column name
  l_key_name := f_get_id_name(p_table_name);
  -- gets system column pairs
  CALL p_format_sys_columns(p_sys_key_val,l_sys_kv_hst,l_sys_kv_rcnt);
  -- processes system columns
  FOR lr_kv IN SELECT * FROM each(l_sys_kv_rcnt) LOOP
      l_cols_rcnt := l_cols_rcnt || lr_kv.key || ',';
      l_vals_rcnt := l_vals_rcnt || quote_nullable(lr_kv.value) || ',';
  END LOOP;
  FOR lr_kv IN SELECT * FROM each(l_sys_kv_hst) LOOP
      l_cols_hst := l_cols_hst || lr_kv.key || ',';
      l_vals_hst := l_vals_hst || quote_nullable(lr_kv.value) || ',';
  END LOOP;
  -- processes business columns
  FOR lr_kv IN SELECT * FROM each(p_business_key_val) LOOP
      l_cols_rcnt := l_cols_rcnt || lr_kv.key || ',';
      l_vals_rcnt := l_vals_rcnt || quote_nullable(lr_kv.value) || ',';
      l_cols_hst := l_cols_hst || lr_kv.key || ',';
      l_vals_hst := l_vals_hst || quote_nullable(lr_kv.value) || ',';
  END LOOP;
  -- removes trailing delimeters
  l_cols_rcnt := l_cols_rcnt || l_key_name;
  l_vals_rcnt := l_vals_rcnt || '''' || l_id || '''::uuid';
  l_cols_hst := l_cols_hst || l_key_name;
  l_vals_hst := l_vals_hst || '''' || l_id || '''::uuid';
  --
  l_sql_rcnt := format('INSERT INTO %I (%s) VALUES (%s)', l_table_rcnt, l_cols_rcnt, l_vals_rcnt);
  CALL p_raise_notice(l_sql_rcnt);
  EXECUTE l_sql_rcnt;
  l_sql_hst := format('INSERT INTO %I (%s) VALUES (%s)', l_table_hst, 'ddm_dml_op,'||l_cols_hst, '''I'','||l_vals_hst);
  CALL p_raise_notice(l_sql_hst);
  EXECUTE l_sql_hst;
  RETURN l_id;
END;
$function$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;
