--liquibase formatted sql
--changeset platform:change-owner splitStatements:false
--validCheckSum: ANY
DO $$
declare 
	r record;
       v_schema varchar := 'registry';
	v_new_owner varchar := '${regOwnerName}';
begin
    for r in
		select 'ALTER TABLE "' || table_schema || '"."' || table_name || '" OWNER TO ' || v_new_owner || ';' as a
		from information_schema.tables
		where table_schema = v_schema
		union all
		select 'ALTER TABLE "' || sequence_schema || '"."' || sequence_name || '" OWNER TO ' || v_new_owner || ';' as a
		from information_schema.sequences
		where sequence_schema = v_schema
		union all
		select 'ALTER TABLE "' || table_schema || '"."' || table_name || '" OWNER TO ' || v_new_owner || ';' as a
		from information_schema.views
		where table_schema = v_schema
		union all
		select 'ALTER TYPE "' || nsp.nspname || '"."' || t.typname || '" OWNER TO ' || v_new_owner || ';' as a
		from pg_type t
		join pg_roles rol on rol.oid = t.typowner
		join pg_namespace nsp on nsp.oid = t.typnamespace
		where nsp.nspname like v_schema
		  and t.typtype in ('d',
		                  'e')
	loop
              execute r.a;
	end loop;
end$$;