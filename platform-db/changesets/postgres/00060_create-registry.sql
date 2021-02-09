--liquibase formatted sql
--changeset platform:create-registry_owner-roles
--validCheckSum: ANY
-- role registry_owner_role
create role ${regOwnerName} with password '${regOwnerPass}' login;


--changeset platform:create-registry-db runInTransaction:false
create database ${dbName} with owner=${regOwnerName};
