--liquibase formatted sql
--changeset platform:ddm_geoserver_pk_metadata

CREATE TABLE public.ddm_geoserver_pk_metadata (
  table_schema VARCHAR(32) NOT NULL,
  table_name VARCHAR(64) NOT NULL,
  pk_column VARCHAR(32) NOT NULL,
  pk_column_idx INTEGER,
  pk_policy VARCHAR(32),
  pk_sequence VARCHAR(64),
  unique (table_schema, table_name, pk_column)
);

--liquibase formatted sql
--changeset platform:grant-to-geo-metadata context:"pub"
grant select on public.ddm_geoserver_pk_metadata to ${geoserverRoleName};
grant select on public.ddm_liquibase_metadata to ${geoserverRoleName};