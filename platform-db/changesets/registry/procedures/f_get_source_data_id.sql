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
--changeset platform:f_get_source_data_id splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE FUNCTION f_get_source_data_id(p_table_name TEXT,p_id_name TEXT,p_source_col_name TEXT,p_source_col_value TEXT,p_to_insert BOOLEAN DEFAULT FALSE,p_created_by TEXT DEFAULT NULL)
 RETURNS UUID
 LANGUAGE plpgsql
AS $function$
DECLARE
  l_id UUID;
  l_sql TEXT;
BEGIN
  -- looks if value aleady exists
  l_sql := format('SELECT %I FROM %I WHERE %I = lower(%L)', p_id_name, p_table_name, p_source_col_name,p_source_col_value);
  CALL p_raise_notice(l_sql);
  EXECUTE l_sql INTO l_id;
  -- inserts row if it doesn't exist
  IF l_id IS NULL AND p_to_insert THEN
    l_id := uuid_generate_v4();
    l_sql := format('INSERT INTO %I (%I,%I,created_by) VALUES (%L,lower(%L),%L)', p_table_name, p_id_name, p_source_col_name, l_id, p_source_col_value, p_created_by);
    CALL p_raise_notice(l_sql);
    EXECUTE l_sql;
  END IF;
  --
  RETURN l_id;
END;
$function$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;
