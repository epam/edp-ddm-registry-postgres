--liquibase formatted sql
--changeset platform:create-extensions-fdw
-- Extension for P_DML procedure hstore parameter
create extension if not exists hstore;

-- Extension for contains indexes
create extension if not exists pg_trgm;

-- Extension to generate uuid values
create extension if not exists "uuid-ossp";

-- Extension and server to enable external tables
create extension if not exists file_fdw;

CREATE SERVER IF NOT EXISTS srv_file_fdw FOREIGN DATA WRAPPER file_fdw;