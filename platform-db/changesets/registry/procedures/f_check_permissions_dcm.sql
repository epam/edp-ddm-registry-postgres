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
--changeset platform:f_check_permissions_dcm splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE FUNCTION public.f_check_permissions_dcm(p_table_name text, p_key_name text, p_uuid uuid, p_columns_arr text[], p_roles_arr text[], OUT r_is_check_passed boolean, OUT r_columns4rbac_arr text[])
 RETURNS record
 LANGUAGE plpgsql
AS $function$
declare
  c_unit_name       text := 'f_check_permissions_dcm';
  l_sql             text;
  l_column_name     text;
  l_dcm_access_role type_access_role[];
  i                 record;
begin

  call p_raise_notice(format('%s: p_table_name [%s]', c_unit_name, p_table_name));
  call p_raise_notice(format('%s: p_key_name [%s]', c_unit_name, p_key_name));
  call p_raise_notice(format('%s: p_uuid [%s]', c_unit_name, p_uuid));
  call p_raise_notice(format('%s: p_columns_arr (list of updated columns) [%s]', c_unit_name, p_columns_arr));
  call p_raise_notice(format('%s: p_roles_arr (list of user roles) [%s]', c_unit_name, p_roles_arr));

  r_is_check_passed := true;
  r_columns4rbac_arr := p_columns_arr;

  -- check if dcm_access_role column exists in p_table_name
  l_sql := 'select column_name
              from information_schema.columns
              where table_schema = ''registry''
                and table_name = ''' || p_table_name || '''
                and column_name = ''dcm_access_role''
           ';
  execute l_sql into l_column_name;

  if l_column_name is null then
    call p_raise_notice(format('%s: column [dcm_access_role] not found in table [%s] => dcm check is skipped', c_unit_name, p_table_name));
    return;
  end if;


  -- get dcm_access_role value
  l_sql := 'select dcm_access_role from ' || p_table_name || ' where ' || p_key_name || ' = ''' || p_uuid || '''';
  execute l_sql into l_dcm_access_role;

  -- check if dcm_access_role is empty
  call p_raise_notice(format('%s: l_dcm_access_role [%s]', c_unit_name, l_dcm_access_role));
  call p_raise_notice(format('%s: cardinality(l_dcm_access_role) [%s]', c_unit_name, cardinality(l_dcm_access_role)));
  if l_dcm_access_role is null or cardinality(l_dcm_access_role) = 0 then
    call p_raise_notice(format('%s: dcm_access_role is empty => dcm check is skipped', c_unit_name));
    return;
  end if;


  -- check permissions for columns specified in data_column_name
  foreach i in array l_dcm_access_role loop
    call p_raise_notice(format('%s: i.data_column_name [%s], i.access_role[%s]', c_unit_name, i.data_column_name, i.access_role));

    if trim(coalesce(i.data_column_name, '')) = '' then
      call p_raise_notice(format('%s: data_column_name is empty => skip', c_unit_name));
      continue;
    end if;

    if not (i.data_column_name = any(p_columns_arr)) then
      call p_raise_notice(format('%s: column [%s] not found in the list of updated columns => skip', c_unit_name, i.data_column_name));
      continue;
    end if;

    -- NB. i.access_role is not checked for null or empty

    if p_roles_arr is null or cardinality(p_roles_arr) = 0 or not (p_roles_arr && i.access_role) then
      call p_raise_notice(format('%s: column [%s], ' || case when p_roles_arr is null or cardinality(p_roles_arr) = 0 then
                                                               'list of user roles is empty'
                                                             else
                                                               'none of user roles found in access_role'
                                                        end || ' => access denied', c_unit_name, i.data_column_name));
      r_is_check_passed := false;
      return;
    end if;

    -- access permitted => exclude i.data_column_name from the list of updated columns for further checks
    call p_raise_notice(format('%s: column [%s], one of user roles found in access_role => access permitted', c_unit_name, i.data_column_name));
    r_columns4rbac_arr := array_remove(r_columns4rbac_arr, i.data_column_name);

  end loop;

  call p_raise_notice(format('%s: r_columns4rbac_arr [%s]', c_unit_name, r_columns4rbac_arr));
  return;
end;
$function$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;
