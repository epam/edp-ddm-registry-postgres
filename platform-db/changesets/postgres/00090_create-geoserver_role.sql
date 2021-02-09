--liquibase formatted sql
--changeset platform:create-geoserver-role context:"pub"
--validCheckSum: ANY
-- role geoserver_role
create role ${geoserverRoleName} with password '${geoserverRolePass}' login;

--changeset platform:geoserver_role-grant context:"pub"
grant connect on database ${dbName} to ${geoserverRoleName};
grant ${appRoleName} to ${geoserverRoleName};