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
--changeset platform:f_trg_check_m2m_integrity splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE FUNCTION f_trg_check_m2m_integrity()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
declare
  v_field_for_check text;
  v_id_for_check    text;
  v_id_new          text;
  v_table           text;
  v_array_field     text;
  v_is_value_found  integer;
begin
  -- set local variables
  v_field_for_check := tg_argv[0];
  execute 'select $1.' || v_field_for_check into v_id_for_check using old;
  execute 'select $1.' || v_field_for_check into v_id_new using new;
  v_table := tg_argv[1];
  v_array_field := tg_argv[2];
  -- if check needed
  if tg_op = 'DELETE' or tg_op = 'UPDATE' and v_id_for_check <> v_id_new then
    -- check if value exists in reference table
    execute 'select 1 from ' || v_table || ' where ''' || v_id_for_check || ''' = any(' || v_array_field || ') limit 1' into v_is_value_found;
    if v_is_value_found is not null then
      raise exception '% = ''%'' in "%" is used in "%.%". Operation % is aborted.', v_field_for_check, v_id_for_check, tg_table_name, v_table, v_array_field, tg_op;
    end if;
  end if;
  -- return
  if tg_op = 'DELETE' then
    return old;
  else
    return new;
  end if;
end;
$function$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;
