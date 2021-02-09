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
--changeset platform:p_version_control splitStatements:false stripComments:false runOnChange:true

-- create procedure
CREATE OR REPLACE PROCEDURE p_version_control(p_version TEXT, p_update BOOLEAN)
LANGUAGE plpgsql
AS $procedure$
DECLARE
    c_change_type TEXT := 'versioning';
    c_change_name TEXT := 'registry_version';
    c_attr_curr TEXT := 'current';
    c_attr_prev TEXT := 'previous';
    l_ver_curr TEXT;
    l_ver_prev TEXT;
    l_ret text;
BEGIN
    -- check input params
    if p_version is null then
      raise exception 'New registry version is not set (p_version is null).';
    end if;

    if not exists (select 1 where p_version ~ '^\d+[.]\d+[.]\d+$') then
      raise exception 'Format of the new registry version is not followed. Expecting x.x.x (for example 1.0.0).';
    end if;

    -- get current version
    SELECT attribute_value INTO l_ver_curr FROM ddm_liquibase_metadata
    WHERE change_type = c_change_type AND change_name = c_change_name AND attribute_name = c_attr_curr;

    -- get previous version
    SELECT attribute_value INTO l_ver_prev FROM ddm_liquibase_metadata
    WHERE change_type = c_change_type AND change_name = c_change_name AND attribute_name = c_attr_prev;

    -- update
    IF p_update THEN
        -- change current version
        UPDATE ddm_liquibase_metadata SET attribute_value = p_version
        WHERE change_type = c_change_type AND change_name = c_change_name AND attribute_name = c_attr_curr
        returning attribute_value into l_ret;

        --
        IF l_ret IS NULL THEN
            INSERT INTO ddm_liquibase_metadata (change_name, change_type, attribute_name, attribute_value) VALUES (c_change_name, c_change_type, c_attr_curr, p_version);
        END IF;

        -- change previous version
        UPDATE ddm_liquibase_metadata SET attribute_value = l_ver_curr
        WHERE change_type = c_change_type AND change_name = c_change_name AND attribute_name = c_attr_prev
        returning attribute_value into l_ret;

        --
        IF l_ret IS NULL THEN
            INSERT INTO ddm_liquibase_metadata (change_name, change_type, attribute_name, attribute_value) VALUES (c_change_name, c_change_type, c_attr_prev, coalesce(l_ver_curr,'N/A'));
        END IF;
    ELSE
        IF coalesce(l_ver_curr, 'N/A') = p_version THEN
            RAISE EXCEPTION 'ERROR: new registry version must differ from current version' USING ERRCODE = '20005';
        END IF;
    END IF;
END;
$procedure$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;

-- drop previous version of procedure
DROP PROCEDURE IF EXISTS p_version_control(TEXT);

