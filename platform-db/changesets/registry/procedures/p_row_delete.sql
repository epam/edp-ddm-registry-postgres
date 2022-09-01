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
--changeset platform:p_row_delete splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE PROCEDURE p_row_delete(p_table_name TEXT, p_uuid uuid, p_sys_key_val hstore, p_roles_arr TEXT[] DEFAULT NULL)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  l_key_name TEXT;
  c_history_suffix CONSTANT TEXT := '_hst';
  l_table_hst TEXT := p_table_name||c_history_suffix;
  l_table_rcnt TEXT := p_table_name;
  --
  lr_kv RECORD;
  lr_rcnt RECORD;
  l_kv_hst hstore;
  --
  l_cols_hst TEXT := '';
  l_vals_hst TEXT := '';
  --
  l_sys_kv_hst hstore;
  l_sys_kv_rcnt hstore;
  --
  l_sql_hst TEXT;
  l_sql_rcnt TEXT;
  l_cnt SMALLINT;
BEGIN
  -- check permissions
  IF NOT f_check_permissions(p_table_name, p_roles_arr, 'D') THEN
    RAISE EXCEPTION 'ERROR: Permission denied' USING ERRCODE = '20003';
  END IF;
  -- gets pkey column name
  l_key_name := f_get_id_name(p_table_name);
  CALL p_raise_notice(l_key_name);
  -- gets system column pairs
  CALL p_format_sys_columns(p_sys_key_val,l_sys_kv_hst,l_sys_kv_rcnt);
  -- gets current values
  EXECUTE format('SELECT * FROM %I WHERE %I = ''%s''::uuid', l_table_rcnt, l_key_name, p_uuid) INTO lr_rcnt;
  --
  GET DIAGNOSTICS l_cnt = ROW_COUNT;
  IF l_cnt = 0 THEN
    RAISE EXCEPTION 'ERROR: There is no row in table [%] with [% = ''%'']', l_table_rcnt, l_key_name, p_uuid USING ERRCODE = '20002';
  END IF;
  --
  l_kv_hst := hstore(lr_rcnt) - akeys(l_sys_kv_rcnt) || l_sys_kv_hst;
  CALL p_raise_notice(l_kv_hst::text);
  -- processes columns
  FOR lr_kv IN SELECT * FROM each(l_kv_hst) LOOP
      l_cols_hst := l_cols_hst || lr_kv.key || ',';
      l_vals_hst := l_vals_hst || quote_nullable(lr_kv.value) || ',';
  END LOOP;
  -- removes trailing delimeters
  l_cols_hst := trim(trailing ',' from l_cols_hst);
  l_vals_hst := trim(trailing ',' from l_vals_hst);
  --
  l_sql_rcnt := format('DELETE FROM %I WHERE %I = ''%s''::uuid', l_table_rcnt, l_key_name, p_uuid);
  CALL p_raise_notice(l_sql_rcnt);
  EXECUTE l_sql_rcnt;
  l_sql_hst := format('INSERT INTO %I (%s) VALUES (%s)', l_table_hst, 'ddm_dml_op,'||l_cols_hst, '''D'','||l_vals_hst);
  CALL p_raise_notice(l_sql_hst);
  EXECUTE l_sql_hst;
END;
$procedure$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;
