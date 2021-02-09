--liquibase formatted sql
--changeset platform:rename-file-attributes
ALTER TYPE type_file RENAME ATTRIBUTE ceph_key TO id;
ALTER TYPE type_file RENAME ATTRIBUTE file_checksum TO checksum;