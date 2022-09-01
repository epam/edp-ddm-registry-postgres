--liquibase formatted sql
--changeset platform:create-settings-roles context:"pub"
--validCheckSum: ANY
-- role settings_role
create role ${settRoleName} with password '${settRolePass}' login;

--changeset platform:create-settings-db runInTransaction:false context:"pub"
create database settings with owner=${settRoleName};