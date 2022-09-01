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
--changeset platform:f_check_permissions splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE FUNCTION public.f_check_permissions(p_object_name text, p_roles_arr text[], p_operation type_operation DEFAULT 'S'::type_operation, p_columns_arr text[] DEFAULT NULL::text[])
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
  c_unit_name text := 'f_check_permissions';
  l_ret BOOLEAN;
  l_is_role_found integer;
BEGIN

  call p_raise_notice(format('%s: p_object_name [%s]', c_unit_name, p_object_name));
  call p_raise_notice(format('%s: p_roles_arr (list of user roles) [%s]', c_unit_name, p_roles_arr));
  call p_raise_notice(format('%s: p_operation [%s]', c_unit_name, p_operation));
  call p_raise_notice(format('%s: p_columns_arr (list of updated columns) [%s]', c_unit_name, p_columns_arr));

  -- check list of user roles
  if p_roles_arr is not null and cardinality(p_roles_arr) = 4 then
    select 1
      into l_is_role_found
      from (select unnest(p_roles_arr) as role) as t
      where t.role is not null
      limit 1;
    if l_is_role_found is null then
      call p_raise_notice(format('%s: list of user roles has four null elements => system role marker => rbac check is skipped', c_unit_name));
      return true;
    end if;
  end if;

  -- check if table is RBAC regulated
  SELECT count(1) = 0 INTO l_ret FROM (SELECT 1 FROM ddm_role_permission WHERE object_name = p_object_name LIMIT 1) s;
  IF l_ret THEN
    call p_raise_notice(format('%s: table [%s] is not RBAC regiulated => rbac check is skipped', c_unit_name, p_object_name));
    RETURN l_ret;
  END IF;

  -- check permission for all columns
  call p_raise_notice(format('%s: list of user roles for check [%s]', c_unit_name, array_append(p_roles_arr,'isAuthenticated')));
  SELECT count(1) > 0 INTO l_ret FROM ddm_role_permission
  WHERE object_name = p_object_name AND operation = p_operation AND role_name = ANY(array_append(p_roles_arr,'isAuthenticated')) AND trim(coalesce(column_name, '')) = '';
  --
  if l_ret then
    call p_raise_notice(format('%s: table [%s], operation [%s], one of user roles found => access permitted', c_unit_name, p_object_name, p_operation));
    return l_ret;
  elsif not l_ret and p_operation in ('S', 'I', 'D') then
    call p_raise_notice(format('%s: table [%s], operation [%s], none of user roles found => access denied', c_unit_name, p_object_name, p_operation));
    return l_ret;
  end if;

  -- we are here if operation = U and permission for all columns is not set

  -- check the list of updated columns
  if p_columns_arr is null or cardinality(p_columns_arr) = 0 then
    call p_raise_notice(format('%s: table [%s], operation [%s], none of user roles found, list of updated columns is empty => access denied', c_unit_name, p_object_name, p_operation));
    return false;
  end if;

  -- check permissions per column
  SELECT count(DISTINCT column_name) = array_length(p_columns_arr, 1) INTO l_ret FROM ddm_role_permission
  WHERE object_name = p_object_name AND operation = p_operation AND role_name = ANY(array_append(p_roles_arr,'isAuthenticated')) AND column_name = ANY(p_columns_arr);
  --
  call p_raise_notice(format('%s: table [%s], operation [%s] => access ' || case when l_ret then 'permitted' else 'denied' end, c_unit_name, p_object_name, p_operation));
  RETURN l_ret;

END;
$function$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;
