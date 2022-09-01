--liquibase formatted sql
--changeset platform:create-view-audit_event_security_event_v runOnChange:true
create or replace view audit_event_security_event_v as
select id
     , request_id
     , application_name
     , name
     , type
     , timestamp
     , user_keycloak_id
     , user_name
     , user_drfo
     , source_system
     , source_application
     , source_business_process
     , source_business_process_definition_id
     , source_business_process_instance_id
     , source_business_activity
     , source_business_activity_id
     , context::jsonb ->> 'action'::text    as action
     , context::jsonb 						as cntx
  from audit_event
  where type = 'SECURITY_EVENT'::text;

  revoke all on audit_event_security_event_v from public;

  grant select on audit_event_security_event_v to ${anRoleName} 