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
--changeset platform:p_row_update splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE PROCEDURE public.p_row_update(p_table_name text, p_uuid uuid, p_sys_key_val hstore, p_business_key_val hstore, p_roles_arr text[] DEFAULT NULL::text[])
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
  l_sys_kv_rcnt hstore;
  --
  l_cols_hst TEXT := '';
  l_vals_hst TEXT := '';
  l_sys_kv_hst hstore;
  --
  l_upd_list TEXT := '';
  --
  l_sql_hst TEXT;
  l_sql_rcnt TEXT;
  l_cnt SMALLINT;
  --
  l_is_check_passed boolean;
  l_columns4rbac_arr text[];
BEGIN
  -- gets pkey column name
  l_key_name := f_get_id_name(p_table_name);
  -- processes business columns
  FOR lr_kv IN SELECT * FROM each(p_business_key_val) LOOP
      l_cols_hst := l_cols_hst || lr_kv.key || ',';
      l_vals_hst := l_vals_hst || quote_nullable(lr_kv.value) || ',';
  END LOOP;
  --
  -- check permissions based on Data Classification Model (dcm)
  select r_is_check_passed, r_columns4rbac_arr
    into l_is_check_passed, l_columns4rbac_arr
    from f_check_permissions_dcm (p_table_name, l_key_name, p_uuid, string_to_array(rtrim(l_cols_hst, ','), ','), p_roles_arr);
  if not l_is_check_passed then
    RAISE EXCEPTION '(dcm) Permission denied' USING ERRCODE = '20003';
  end if;
  --
  -- check permissions based on RBAC
  -- if any columns left after previous check
  if cardinality(l_columns4rbac_arr) > 0 and 
  NOT f_check_permissions(p_table_name, p_roles_arr, 'U', l_columns4rbac_arr) THEN
    RAISE EXCEPTION '(rbac) Permission denied' USING ERRCODE = '20003';
  END IF;
  -- gets system column pairs
  CALL p_format_sys_columns(p_sys_key_val,l_sys_kv_hst,l_sys_kv_rcnt);
  -- creates update list
  FOR lr_kv IN SELECT * FROM each(l_sys_kv_rcnt - akeys(l_sys_kv_hst) || p_business_key_val) LOOP
    l_upd_list := trim(leading ',' from concat_ws(',', l_upd_list, lr_kv.key || '=' || quote_nullable(lr_kv.value)));
  END LOOP;
  -- makes update
  l_sql_rcnt := format('UPDATE %I SET %s WHERE %I = ''%s''::uuid', l_table_rcnt, l_upd_list, l_key_name, p_uuid);
  CALL p_raise_notice(l_sql_rcnt);
  EXECUTE l_sql_rcnt;
  -- raises error if row doesn't exist
  GET DIAGNOSTICS l_cnt = ROW_COUNT;
  IF l_cnt = 0 THEN
    RAISE EXCEPTION 'ERROR: There is no row in table [%] with [% = ''%'']', l_table_rcnt, l_key_name, p_uuid USING ERRCODE = '20002';
  END IF;
  --
  -- gets current values after update
  EXECUTE format('SELECT * FROM %I WHERE %I = ''%s''::uuid', l_table_rcnt, l_key_name, p_uuid) INTO lr_rcnt;
  --
  l_kv_hst := hstore(lr_rcnt) - akeys(l_sys_kv_rcnt) || l_sys_kv_hst;
  CALL p_raise_notice(l_kv_hst::text);
  -- processes columns
  l_cols_hst := '';
  l_vals_hst := '';
  FOR lr_kv IN SELECT * FROM each(l_kv_hst) LOOP
      l_cols_hst := l_cols_hst || lr_kv.key || ',';
      l_vals_hst := l_vals_hst || quote_nullable(lr_kv.value) || ',';
  END LOOP;
  -- removes trailing delimeters
  l_cols_hst := trim(trailing ',' from l_cols_hst);
  l_vals_hst := trim(trailing ',' from l_vals_hst);
  --
  l_sql_hst := format('INSERT INTO %I (%s) VALUES (%s)', l_table_hst, 'ddm_dml_op,'||l_cols_hst, '''U'','||l_vals_hst);
  CALL p_raise_notice(l_sql_hst);
  EXECUTE l_sql_hst;
END;
$procedure$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;
