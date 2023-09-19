--liquibase formatted sql
--changeset platform:create-redash-admin context:"sub"
--validCheckSum: ANY
-- role redash_admin_role
create role ${redashAdminRoleName} with password '${redashAdminRolePass}' login;


--changeset platform:create-redash_admin-db runInTransaction:false context:"sub"
create database redash_admin with owner=${redashAdminRoleName};
