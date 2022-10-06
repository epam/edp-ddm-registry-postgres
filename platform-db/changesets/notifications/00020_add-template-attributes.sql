--liquibase formatted sql
--changeset platform:create-notification-attrs

-- notification_template model
alter table notification_template
    add column title text,
    add column ext_template_id text,
    add column ext_published_at timestamptz,
    add constraint notification_template__ext_template__uk unique (ext_template_id);

create table if not exists notification_template_attr (
	id uuid not null default uuid_generate_v4(),
	template_id uuid not null,
	name text not null,
	value text not null,
	constraint notification_template_attr__id__pk primary key (id),
	constraint notification_template_attr__template__fk foreign key (template_id)
	    references notification_template (id),
	constraint notification_template_attr__template_name__uk unique (template_id, name)
);

-- revoke access from notification_template_publisher_user
revoke all on notification_template from ${notificationTemplatePublisherName};

-- grant access for notification_service_user
grant insert, update, delete on notification_template to ${notificationServiceName};

revoke all on notification_template_attr from public;

grant select, insert, update, delete on notification_template_attr to ${notificationServiceName};