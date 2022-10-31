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
--changeset platform:f_like_escape splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE FUNCTION f_like_escape(text)
  RETURNS text
  LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
AS $function$
SELECT replace(replace(replace($1
    , '\', '\\') -- must come 1st
    , '%', '\%')
    , '_', '\_');
$function$
;

