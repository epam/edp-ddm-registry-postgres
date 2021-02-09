--liquibase formatted sql
--changeset platform:create-other-extensions
-- extension pg_stat_statements
create extension if not exists pg_stat_statements;