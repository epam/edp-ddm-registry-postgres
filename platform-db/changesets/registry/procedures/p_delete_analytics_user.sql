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
--changeset platform:p_delete_analytics_user splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE PROCEDURE p_delete_analytics_user(p_user_name TEXT)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  v_user_name text := replace(p_user_name, '"', '');
BEGIN
     v_user_name :='"'||v_user_name||'"'; 
     EXECUTE 'REVOKE ALL PRIVILEGES ON DATABASE ' || current_database() || ' FROM ' || v_user_name || ';';
     EXECUTE 'REVOKE ALL PRIVILEGES ON SCHEMA public  FROM ' || v_user_name || ';';
     EXECUTE 'REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM ' || v_user_name || ';';
     EXECUTE 'REVOKE ALL PRIVILEGES ON ALL ROUTINES IN SCHEMA public FROM ' || v_user_name || ';';

     EXECUTE 'REVOKE ALL PRIVILEGES ON SCHEMA registry  FROM ' || v_user_name || ';';
     EXECUTE 'REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA registry FROM ' || v_user_name || ';';
     EXECUTE 'REVOKE ALL PRIVILEGES ON ALL ROUTINES IN SCHEMA registry FROM ' || v_user_name || ';';

     EXECUTE 'DROP ROLE ' || v_user_name || ';';

 END;
$procedure$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;