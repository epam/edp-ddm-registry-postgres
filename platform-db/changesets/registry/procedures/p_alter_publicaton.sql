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
--changeset platform:p_alter_publicaton splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE PROCEDURE p_alter_publicaton(p_publication_name TEXT)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  l_table_list TEXT;
BEGIN
  l_table_list := f_get_tables_to_replicate(p_publication_name);
  IF l_table_list IS NOT NULL THEN
    EXECUTE 'ALTER PUBLICATION ' || p_publication_name || ' ADD TABLE ' || l_table_list || ';';
  END IF;
END;
$procedure$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;
