--liquibase formatted sql
--changeset platform:publication-analytical_pub context:"pub"
-- Publication for Logical replication
CREATE PUBLICATION analytical_pub /*FOR ALL TABLES*/ WITH (publish = 'insert, update, delete, truncate');