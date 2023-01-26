--liquibase formatted sql
--changeset platform:app-role-grant context:"pub"
grant connect on database ${dbName} to ${appRoleName};


--changeset platform:admin-role-grant context:"pub"
grant connect on database ${dbName} to ${admRoleName};


--changeset platform:registry-regulation-management-role-grant context:"pub"
grant connect on database ${dbName} to ${regRegulationRoleName};


--changeset platform:analytics-admin-role-grant context:"sub"
grant connect on database ${dbName} to ${anAdmName};


--changeset platform:historical_data_role-grant context:"sub"
grant connect on database ${dbName} to ${histRoleName};
