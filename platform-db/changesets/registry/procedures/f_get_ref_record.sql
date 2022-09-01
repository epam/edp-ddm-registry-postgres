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
--changeset platform:f_get_ref_record splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE FUNCTION f_get_ref_record(p_ref_path TEXT)
 RETURNS refs
 LANGUAGE plpgsql
AS $function$
DECLARE
  l_ret refs;
BEGIN
  l_ret.lookup_col := substring(p_ref_path,'lookup_col:(.*),ref_table:');
  l_ret.ref_table := substring(p_ref_path,'ref_table:(.*),ref_col:');
  l_ret.ref_col := substring(p_ref_path,'ref_col:(.*),ref_id:');
  l_ret.ref_id := coalesce(substring(p_ref_path,'ref_id:(.*),delim:'), substring(p_ref_path,'ref_id:(.*)\)'));
  l_ret.list_delim := coalesce(substring(p_ref_path,'delim:(.)\)'), ',')::char(1);
  --
  RETURN l_ret;
END;
$function$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;
