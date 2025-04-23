--liquibase formatted sql
--changeset platform:bpm_history_process-update-index
drop index if exists bpm_history_process__start_user_id__state__start_time__i;

drop index if exists bpm_history_process__start_user_id__state__end_time__i;

create index if not exists bpm_hp__start_user_id__state__i on bpm_history_process
  using btree (start_user_id asc nulls last, state asc nulls last);

create index if not exists bpm_hp__start_user_id__state_active__start_time__i on bpm_history_process
  using btree (start_user_id asc, start_time asc)
  where super_process_instance_id is null and state in ('ACTIVE', 'SUSPENDED');

create index if not exists bpm_hp__start_user_id__state_active__end_time__i on bpm_history_process
  using btree (start_user_id asc, end_time desc)
  where super_process_instance_id is null and state in ('ACTIVE', 'SUSPENDED');

create index if not exists bpm_hp__start_user_id__state_completed__start_time__i on bpm_history_process
  using btree (start_user_id ASC, start_time ASC)
  where super_process_instance_id is null and state in ('EXTERNALLY_TERMINATED', 'COMPLETED');

create index if not exists bpm_hp__start_user_id__state_completed__end_time__i on bpm_history_process
  using btree (start_user_id asc, end_time desc)
  where super_process_instance_id is null and state in ('EXTERNALLY_TERMINATED', 'COMPLETED');

--changeset platform:bpm_history_task-add-index
create index if not exists bpm_ht__assignee__root_process_instance_id__i on bpm_history_task
  using btree (assignee, root_process_instance_id);



