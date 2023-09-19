--liquibase formatted sql
--changeset platform:create-type-object
CREATE TYPE type_object AS ENUM ('table','search_condition');

--liquibase formatted sql
--changeset platform:add-object-type-column
ALTER TABLE public.ddm_role_permission ADD COLUMN object_type TYPE_OBJECT NOT NULL DEFAULT 'table';