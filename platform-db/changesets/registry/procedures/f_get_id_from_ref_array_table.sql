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
--changeset platform:f_get_id_from_ref_array_table splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE FUNCTION f_get_id_from_ref_array_table(p_ref_table TEXT,p_ref_col TEXT,p_ref_id TEXT,p_lookup_val TEXT,p_delim CHAR)
 RETURNS TEXT
 LANGUAGE plpgsql
AS $function$
DECLARE
  l_ret TEXT;
  l_arr_lookup TEXT[];
  l_arr_id TEXT[];
begin
  -- get lookup values from the list
  l_arr_lookup := string_to_array(rtrim(ltrim(p_lookup_val,'{'),'}'),p_delim);
  CALL p_raise_notice(l_arr_lookup::text);
  -- build up an appropriate uuid list
  IF l_arr_lookup IS NOT NULL THEN
    FOR i IN 1..array_upper(l_arr_lookup, 1) loop
      l_arr_id[i] := f_get_id_from_ref_table(p_ref_table, p_ref_col, p_ref_id, trim(l_arr_lookup[i],' '));
      l_ret := array_to_string(l_arr_id,',');
    END LOOP;
  END IF;
  --
  RETURN l_ret;
END;
$function$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;
