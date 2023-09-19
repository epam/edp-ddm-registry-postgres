--liquibase formatted sql
--changeset platform:create-redash-viewer context:"sub"
--validCheckSum: ANY
-- role redash_viewer_role
create role ${redashViewerRoleName} with password '${redashViewerRolePass}' login;


--changeset platform:create-redash_viewer-db runInTransaction:false context:"sub"
create database redash_viewer with owner=${redashViewerRoleName};
