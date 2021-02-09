--liquibase formatted sql
--changeset platform:create-process_history-roles context:"pub"
--validCheckSum: ANY
-- role process_history_role
create role ${processHistoryRoleName} with password '${processHistoryRolePass}' login;

--changeset platform:create-process_history-db runInTransaction:false context:"pub"
create database process_history /*with owner=${processHistoryRoleName}*/;
