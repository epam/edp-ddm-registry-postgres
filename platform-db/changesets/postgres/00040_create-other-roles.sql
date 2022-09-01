--liquibase formatted sql
--changeset platform:create-other-roles
--validCheckSum: ANY
-- role application_role
create role ${appRoleName} with password '${appRolePass}' login;


--changeset platform:create-admin-role context:"pub"
--validCheckSum: ANY
create role ${admRoleName} with password '${admRolePass}' login;


--changeset platform:create-analytics-admin-role context:"sub"
--validCheckSum: ANY
create role ${anAdmName} with password '${anAdmPass}' login;


--changeset platform:create-historical_data_role context:"sub"
--validCheckSum: ANY
create role ${histRoleName} with password '${histRolePass}' login;