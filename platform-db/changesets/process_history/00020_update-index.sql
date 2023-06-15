--liquibase formatted sql
--changeset platform:bpm_history_task-update-index

drop index bpm_history_task__assignee__end_time__i;
create index bpm_history_task__assignee__end_time__root_pi_id__i on bpm_history_task using btree (assignee, end_time desc, root_process_instance_id);
