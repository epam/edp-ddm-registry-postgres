--liquibase formatted sql
--changeset platform:create-audit-roles context:"pub"
--validCheckSum: ANY
-- role analytics_admin
create role ${anAdmName} with password '${anAdmPass}' login;
-- role analytics_auditor
create role ${anRoleName} with password '${anRolePass}' login;
-- role audit_service_user
create role ${anSvcName} with password '${anSvcPass}' login;

--changeset platform:create-audit-db runInTransaction:false context:"pub"
create database audit /*with owner=${anAdmName}*/;