--liquibase formatted sql
--changeset platform:notification-channels

-- notification_channel
create type channel_enum AS enum ('EMAIL', 'DIIA');

create table if not exists notification_channel (
    id uuid not null default uuid_generate_v4(),
    settings_id uuid not null,
    channel channel_enum not null,
    address text,
    deactivation_reason text,
    is_activated boolean not null default false,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
	constraint notification_channel__id__pk primary key (id),
	constraint notification_channel__settings_fk foreign key (settings_id) references settings (settings_id),
	constraint notification_channel__settings_channel__uk unique (settings_id, channel)
);

alter table notification_channel owner to ${settRoleName};

revoke all on notification_channel from public;

-- channel migration
insert into notification_channel (settings_id, channel, address, is_activated)
    select settings_id, 'EMAIL', email, true from settings;

-- alter settings
alter table settings rename column settings_id to id;
alter table settings
    drop column email,
    drop column phone,
    drop column communication_is_allowed;
