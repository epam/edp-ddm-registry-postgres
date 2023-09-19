--liquibase formatted sql
--changeset platform:create-camunda-db runInTransaction:false context:"pub"
--preconditions onFail:MARK_RAN
--precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM pg_database where datname='camunda'
CREATE DATABASE camunda with owner=${pubUser};

--changeset platform:create-camunda-roles context:"pub"
--validCheckSum: ANY
-- role bpm_service_user
create role ${bpmServiceName} with password '${bpmServicePass}' login;
-- role bp_admin_portal_service_user
create role ${bpAdminPortalServiceName} with password '${bpAdminPortalServicePass}' login;
