--liquibase formatted sql
--changeset platform:historical_data_role-grant-ddm_source context:"sub"
grant select on ddm_source_application to ${histRoleName};
grant select on ddm_source_business_process to ${histRoleName};
grant select on ddm_source_system to ${histRoleName};