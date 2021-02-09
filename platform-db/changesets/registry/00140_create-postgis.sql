--liquibase formatted sql
--changeset platform:create-postgis-extension
create extension if not exists postgis;

--changeset platform:revoke-privileges-on-postgis-tables
revoke select on public.geography_columns from public;
revoke select on public.geometry_columns from public;
revoke select on public.spatial_ref_sys from public;