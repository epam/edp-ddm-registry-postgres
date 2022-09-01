--liquibase formatted sql
--changeset platform:create-registry-schema
create schema if not exists registry;
alter schema registry owner to ${regOwnerName};

alter database ${dbName} set search_path to "$user", registry, public;

--changeset platform:registry-schema-grants
grant usage on schema registry to public;

--changeset platform:create-registry-schema-on-workers
select run_command_on_workers('create schema if not exists registry');
select run_command_on_workers('alter schema registry owner to ${regOwnerName}');

select run_command_on_workers('alter database ${dbName} set search_path to "$user", registry, public');

--changeset platform:registry-schema-grants-on-workers
select run_command_on_workers('grant usage on schema registry to public');
