--liquibase formatted sql
--changeset platform:create-extension-uuid-ossp
create extension if not exists "uuid-ossp";

--changeset platform:create-tables
-- table audit_event
create table if not exists settings (
    settings_id uuid not null default uuid_generate_v4(),
    keycloak_id uuid not null,
    email text,
    phone text,
    communication_is_allowed boolean,
	constraint settings__settings_id__pk primary key (settings_id),
	constraint settings__keycloak_id__uk unique (keycloak_id)
);

alter table settings owner to ${settRoleName};

revoke all on settings from public;