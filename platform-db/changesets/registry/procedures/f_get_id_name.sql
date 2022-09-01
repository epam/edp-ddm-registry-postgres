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
--changeset platform:f_get_id_name splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE FUNCTION public.f_get_id_name(p_table_name TEXT)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
  l_id_name TEXT;
BEGIN
  SELECT cc.column_name INTO STRICT l_id_name
  FROM information_schema.table_constraints c JOIN information_schema.constraint_column_usage cc USING (constraint_name,table_name,table_schema,table_catalog)
  WHERE c.table_name = p_table_name AND c.constraint_type = 'PRIMARY KEY'
  LIMIT 1;
  --
  RETURN l_id_name;
EXCEPTION WHEN OTHERS THEN
  RAISE EXCEPTION  '%: Can''t detect PK for table "%"',SQLERRM, p_table_name USING ERRCODE = SQLSTATE;
END;
$function$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;
