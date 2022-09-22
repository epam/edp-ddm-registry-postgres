--liquibase formatted sql
--changeset platform:create-camunda-db runInTransaction:false context:"pub"
--preconditions onFail:MARK_RAN
--precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM pg_database where datname='camunda'
CREATE DATABASE camunda with owner=${pubUser};
