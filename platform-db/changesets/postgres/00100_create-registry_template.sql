--liquibase formatted sql
--changeset platform:create-registry_template_owner-roles context:"pub"
--validCheckSum: ANY
-- role registry_template_owner_role
create role ${regTemplateOwnerName} with password '${regTemplateOwnerPass}' login createdb;


--changeset platform:create-registry-template-db runInTransaction:false context:"pub"
create database registry_template with owner=${regTemplateOwnerName};
grant ${regOwnerName} to ${regTemplateOwnerName};
