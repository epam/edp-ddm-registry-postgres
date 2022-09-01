--liquibase formatted sql
--changeset platform:create-types
CREATE TYPE type_operation AS ENUM ('S','I','U','D');
CREATE TYPE type_dml AS ENUM ('I','U','D');
CREATE TYPE refs AS(
             ref_table TEXT
            ,ref_col TEXT
            ,ref_id TEXT
            ,lookup_col TEXT
            ,list_delim CHAR(1)
            );
CREATE TYPE type_classification_enum AS ENUM ('private', 'confidential');
CREATE TYPE type_classification AS (
                data_column_name TEXT,
                data_classification type_classification_enum
            );
CREATE TYPE type_access_role AS (
                data_column_name TEXT,
                access_role TEXT []
            );
CREATE TYPE type_file as (
                ceph_key text,
                file_checksum text
            );