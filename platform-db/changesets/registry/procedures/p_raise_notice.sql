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
--changeset platform:p_raise_notice splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE PROCEDURE p_raise_notice(p_string_to_log TEXT)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
--  RAISE NOTICE '%', p_string_to_log;
END;
$procedure$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;
