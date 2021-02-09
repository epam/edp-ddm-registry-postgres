--liquibase formatted sql
--changeset platform:create-extension-uuid-ossp
create extension if not exists "uuid-ossp";

--changeset platform:create-tables
-- table audit_event
create table if not exists audit_event
  ( id                                    text not null default uuid_generate_v4()
  , request_id                            text not null
  , application_name                      text not null
  , name                                  text not null
  , type                                  text not null
  , timestamp                             timestamp without time zone not null
  , user_keycloak_id                      text
  , user_name                             text
  , user_drfo                             text
  , source_system                         text
  , source_application                    text
  , source_business_process               text
  , source_business_process_definition_id text
  , source_business_process_instance_id   text
  , source_business_activity              text
  , source_business_activity_id           text
  , context                               text
  , received                              timestamp without time zone not null default now()
  , constraint audit_event__id__pk primary key (id)
  , constraint audit_event__type__ck check (type in ('USER_ACTION', 'SECURITY_EVENT'))
  );

comment on column audit_event.id                                    is 'Ідентифікатор події в БД';
comment on column audit_event.request_id                            is 'Ідентифікатор запиту з MDC';
comment on column audit_event.application_name                      is 'Назва додатку, який генерує подію';
comment on column audit_event.name                                  is 'Назва події';
comment on column audit_event.type                                  is 'Тип події';
comment on column audit_event.timestamp                             is 'Час, коли сталась подія';
comment on column audit_event.user_keycloak_id                      is 'Ідентифікатор користувача';
comment on column audit_event.user_name                             is 'ПІБ користувача, з яким асоційована подія';
comment on column audit_event.user_drfo                             is 'ДРФО користувача';
comment on column audit_event.source_system                         is 'Назва системи';
comment on column audit_event.source_application                    is 'Назва додатку';
comment on column audit_event.source_business_process               is 'Назва бізнес процесу';
comment on column audit_event.source_business_process_definition_id is 'Ідентифікатор типу бізнес процесу';
comment on column audit_event.source_business_process_instance_id   is 'Ідентифікатор запущеного бізнес процесу';
comment on column audit_event.source_business_activity              is 'Назва кроку в бізнес процесі';
comment on column audit_event.source_business_activity_id           is 'Ідентифікатор кроку в бізнес процесі';
comment on column audit_event.context                               is 'JSON представлення деталей події';
comment on column audit_event.received                              is 'Час, коли повідомлення було записано в БД';

revoke connect on database audit from public;
revoke all on audit_event from public;

grant connect on database audit to ${anAdmName};
grant connect on database audit to ${anRoleName};
grant connect on database audit to ${anSvcName};
grant insert on audit_event to ${anSvcName};