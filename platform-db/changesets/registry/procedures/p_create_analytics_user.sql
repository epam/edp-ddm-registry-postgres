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
--changeset platform:p_create_analytics_user splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE PROCEDURE p_create_analytics_user(p_user_name TEXT, p_user_pwd TEXT)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  v_user_name text := replace(p_user_name, '"', '');
BEGIN
  v_user_name :='"'||v_user_name||'"'; 

  EXECUTE 'CREATE ROLE ' || v_user_name || ' LOGIN PASSWORD ''' || p_user_pwd || ''';';
  EXECUTE 'GRANT CONNECT ON DATABASE ' || current_database() || ' TO ' || v_user_name || ';';

 END;
$procedure$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;