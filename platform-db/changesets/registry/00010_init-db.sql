--liquibase formatted sql

--changeset platform:create-archive-schema
create schema if not exists ${archiveSchema};

alter schema ${archiveSchema} owner to ${regOwnerName};

--changeset platform:set-privileges
-- revoke
revoke connect on database ${dbName} from public;

revoke all privileges on all tables in schema public from public;
revoke all privileges on all routines in schema public from public;

-- grants
-- role registry_owner_role
grant connect on database ${dbName} to ${regOwnerName};
grant all privileges on all tables in schema public to ${regOwnerName};
grant all privileges on all routines in schema public to ${regOwnerName};