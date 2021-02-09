--liquibase formatted sql
--changeset platform:revoke-privileges-on-columnar-tables
revoke select on citus_tables from public;

revoke select on columnar.chunk from public;
revoke select on columnar.chunk_group from public;
revoke select on columnar.options from public;
revoke select on columnar.stripe from public;
