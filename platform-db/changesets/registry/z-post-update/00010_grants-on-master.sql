--liquibase formatted sql
--changeset platform:app-role-post-deploy-grant context:"pub"
grant execute on all routines in schema public to ${appRoleName};

--changeset platform:admin-role-post-deploy-grants context:"pub"
grant select on table ddm_db_changelog to ${admRoleName};
grant select on table ddm_db_changelog_lock to ${admRoleName};
grant select on table ddm_liquibase_metadata to ${admRoleName};
