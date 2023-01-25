--liquibase formatted sql
--changeset platform:publication-analytical_pub context:"pub"
-- Publication for Logical replication
CREATE PUBLICATION analytical_pub /*FOR ALL TABLES*/ WITH (publish = 'insert, update, delete, truncate');

--changeset platform:recreate-logical-slot context:"pub and !template"
-- Recreate logical replication slot for connect to last LSN after create publication command.
SELECT pg_catalog.pg_drop_replication_slot('operational_sub') WHERE EXISTS (SELECT 1 FROM pg_catalog.pg_replication_slots WHERE slot_type = 'logical' AND slot_name = 'operational_sub' AND active='f');
SELECT pg_catalog.pg_create_logical_replication_slot('operational_sub', 'pgoutput') WHERE NOT EXISTS (SELECT 1 FROM pg_catalog.pg_replication_slots WHERE slot_type = 'logical' AND slot_name = 'operational_sub');
