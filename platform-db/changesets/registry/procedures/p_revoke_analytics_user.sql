--liquibase formatted sql
--changeset platform:p_revoke_analytics_user splitStatements:false stripComments:false runOnChange:true
CREATE OR REPLACE PROCEDURE p_revoke_analytics_user(p_user_name text,p_table_name text default null)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  c_obj_pattern TEXT := 'report%v';
  r RECORD;
  is_role_found integer;
  v_user_name text := replace(p_user_name, '"', '');
BEGIN
  if p_table_name is not null then
    if not exists (select from information_schema.views 
                   where table_name = p_table_name 
                   and table_schema = 'registry') then
      raise exception 'Table [%] is not found', p_table_name;
    end if;
    c_obj_pattern := p_table_name;
  end if;
  -- check if role exists
  select 1
    into is_role_found
    from pg_catalog.pg_roles
    where rolname = v_user_name;

  if is_role_found is null then
    raise exception 'Role [%] is not found', v_user_name;
  end if;

  FOR r IN SELECT * FROM information_schema.views WHERE table_name LIKE c_obj_pattern AND table_schema = 'registry' LOOP
    EXECUTE 'REVOKE SELECT ON "' || r.table_name || '" FROM "' || v_user_name || '";';
  END LOOP;
 END;
$procedure$
SECURITY DEFINER
SET search_path = registry, public, pg_temp;