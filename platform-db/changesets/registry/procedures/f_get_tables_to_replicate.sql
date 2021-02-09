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
--changeset platform:f_get_tables_to_replicate splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE FUNCTION f_get_tables_to_replicate(p_publication_name TEXT)
 RETURNS TEXT
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN (SELECT string_agg('"'||table_name||'"', ', ')
            FROM (
                    SELECT table_name
                    FROM information_schema.tables
                    WHERE table_type = 'BASE TABLE'
                        AND (
                            table_schema = 'registry'
                            OR (
                                table_schema = 'public'
                                and table_name like 'ddm_source%'
                            )
                        )
                    EXCEPT
                    SELECT tablename
                    FROM pg_catalog.pg_publication_tables
                    WHERE pubname = p_publication_name
                ) s
         );
END;
$function$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;
