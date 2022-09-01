--liquibase formatted sql
--changeset platform:create-tables
-- table bpm_history_process
create table if not exists bpm_history_process
  ( process_instance_id       text not null
  , super_process_instance_id text
  , process_definition_id     text not null
  , process_definition_key    text not null
  , process_definition_name   text
  , business_key              text
  , start_time                timestamp not null
  , end_time                  timestamp
  , start_user_id             text
  , state                     text not null
  , excerpt_id                text
  , completion_result         text
  , constraint bpm_history_process__process_instance_id__pk primary key (process_instance_id)
  );

create index bpm_history_process__start_user_id__state__end_time__i on bpm_history_process
  using btree (start_user_id, state, end_time desc)
  where super_process_instance_id is null;
create index bpm_history_process__start_user_id__state__start_time__i on bpm_history_process
  using btree (start_user_id, state, start_time)
  where super_process_instance_id is null;

-- table bpm_history_task
create table if not exists bpm_history_task
  ( activity_instance_id     text not null
  , task_definition_key      text not null
  , task_definition_name     text
  , process_instance_id      text not null
  , process_definition_id    text not null
  , process_definition_key   text not null
  , process_definition_name  text
  , root_process_instance_id text not null
  , start_time               timestamp not null
  , end_time                 timestamp
  , assignee                 text
  , constraint bpm_history_task__activity_instance_id__pk primary key (activity_instance_id)
  );

create index bpm_history_task__assignee__end_time__i on bpm_history_task using btree (assignee, end_time desc);
create index bpm_history_task__assignee__start_time__i on bpm_history_task using btree (assignee, start_time);


--changeset platform:set-privileges
-- revoke
revoke connect on database process_history from public;
revoke all privileges on all tables in schema public from public;

-- grants
-- role process_history_role
grant connect on database process_history to ${processHistoryRoleName};
grant select, insert, update on bpm_history_process to ${processHistoryRoleName};
grant select, insert, update on bpm_history_task to ${processHistoryRoleName};
