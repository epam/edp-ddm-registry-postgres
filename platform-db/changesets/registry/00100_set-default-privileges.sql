--liquibase formatted sql
--changeset platform:set-default-privileges
alter default privileges in schema public grant all privileges on tables to ${regOwnerName};
alter default privileges in schema public grant execute on routines to ${regOwnerName};

grant all privileges on all tables in schema public to ${regOwnerName};