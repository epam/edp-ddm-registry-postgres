--liquibase formatted sql
/*
 * Copyright 2022 EPAM Systems.
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
--changeset platform:f_rls_filter splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE FUNCTION f_rls_filter(text)
  RETURNS text[]
  LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
AS $function$
select string_to_array(regexp_replace(regexp_replace(replace(regexp_replace($1
, '[\[\]]|\s|''', '', 'g')
, ',', '%,')
, '$', '%')
, '^%', ''), ',');
$function$
;

