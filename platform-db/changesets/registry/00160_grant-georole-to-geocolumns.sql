--liquibase formatted sql
--changeset platform:grant-to-geocolumns context:"pub"

grant select on public.geography_columns to ${geoserverRoleName};
grant select on public.geometry_columns to ${geoserverRoleName};
grant select on public.spatial_ref_sys to ${geoserverRoleName};