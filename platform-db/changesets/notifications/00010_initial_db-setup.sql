--liquibase formatted sql
--changeset platform:create-extension-uuid-ossp
create extension if not exists "uuid-ossp";

--changeset platform:create-tables
-- table notification_template
create table if not exists notification_template (
	id uuid not null default uuid_generate_v4(),
	name text not null,
	channel text not null,
	content text not null,
	checksum text not null,
	created_at timestamptz not null default now(),
	updated_at timestamptz not null default now(),
	constraint notification_template__id__pk primary key (id),
	constraint notification_template___name__channel__uk unique (name, channel)
);


-- revoke
revoke all on notification_template from public;

-- grants
-- role notification_template_publisher_user
grant select, insert, update, delete on notification_template to ${notificationTemplatePublisherName};

-- grants
-- role notification_service_user
grant select on notification_template to ${notificationServiceName};
