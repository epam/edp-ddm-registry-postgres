--liquibase formatted sql
--changeset platform:subscription-operational_sub runInTransaction:false context:"sub"
--validCheckSum: ANY
-- Subscription for Logical replication
CREATE SUBSCRIPTION operational_sub CONNECTION 'dbname=${dbName} host=${pubHost} user=${pubUser} port=${pubPort}' PUBLICATION analytical_pub;