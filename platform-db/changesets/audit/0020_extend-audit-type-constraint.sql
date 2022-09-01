--liquibase formatted sql
--changeset platform:extend-audit-event-constraint

alter table audit_event drop constraint audit_event__type__ck;
alter table audit_event add constraint audit_event__type__ck check (type in ('USER_ACTION', 'SECURITY_EVENT', 'SYSTEM_EVENT'));