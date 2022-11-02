--liquibase formatted sql
--changeset platform:create-inbox-notification

-- inbox_notification model
create table if not exists inbox_notification (
	id uuid not null default uuid_generate_v4(),
	recipient_id text not null,
	subject text not null,
	message text not null,
	is_acknowledged boolean not null default false,
	created_at timestamptz default now() not null,
	updated_at timestamptz default now() not null,
	constraint inbox_notification__id__pk primary key (id)
);

revoke all on inbox_notification from public;

grant select, insert, update, delete on inbox_notification to ${notificationServiceName};