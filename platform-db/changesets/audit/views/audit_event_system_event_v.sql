--liquibase formatted sql
--changeset platform:create-view-audit_event_system_event_v runOnChange:true
drop view if exists audit_event_system_event_v;
create or replace view audit_event_system_event_v as
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
     , context::jsonb ->> 'userId'::text                     as user_id
     , context::jsonb ->> 'username'::text                   as username
     , context::jsonb ->> 'katottg'::text                    as katottg
     , context::jsonb ->> 'customAttributes'::text           as custom_attributes
     , context::jsonb ->> 'enabled'::text                    as enabled
     , context::jsonb ->> 'realmId'::text                    as realm_id
     , context::jsonb ->> 'realmName'::text                  as realm_name
     , context::jsonb ->> 'clientId'::text                   as client_id
     , context::jsonb ->> 'keycloakClientId'::text           as keycloak_client_id
     , context::jsonb ->> 'roles'::text                      as roles
     , context::jsonb ->> 'sourceFileId'::text               as source_file_id
     , context::jsonb ->> 'sourceFileName'::text             as source_file_name
     , context::jsonb ->> 'sourceFileSHA256Checksum'::text   as source_file_sha256_checksum
     , context::jsonb 						                 as cntx
  from audit_event
  where type = 'SYSTEM_EVENT'::text;

  revoke all on audit_event_system_event_v from public;

  grant select on audit_event_system_event_v to ${anRoleName}