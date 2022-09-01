--liquibase formatted sql
--changeset platform:create-extension-uuid-ossp
create extension if not exists "uuid-ossp";

--changeset platform:create-tables
-- table excerpt_template
create table if not exists excerpt_template (
	id uuid not null default uuid_generate_v4(),
	template_name text not null,
	"template" text not null,
	created_at timestamptz not null default now(),
	updated_at timestamptz not null default now(),
	checksum text not null,
	constraint excerpt_template__id__pk primary key (id),
	constraint excerpt_template__template_name__uk unique (template_name)
);


-- table excerpt_record
create table if not exists excerpt_record (
	id uuid not null default uuid_generate_v4(),
	status text null,
	status_details text null,
	keycloak_id text null,
	checksum text null,
	excerpt_key text null,
	created_at timestamptz not null default now(),
	updated_at timestamptz not null default now(),
	signature_required bool null,
	x_source_system text null,
	x_source_application text null,
	x_source_business_process text null,
	x_source_business_activity text null,
	constraint excerpt_record__id__pk primary key (id)
);


-- revoke
revoke all on excerpt_template from public;
revoke all on excerpt_record from public;


-- grants
-- role excerpt_exporter
grant select, insert, update, delete on excerpt_template to ${excerptExporterName};


-- role excerpt_service_user
grant select on excerpt_template to ${excerptSvcName};

grant select, insert on excerpt_record to ${excerptSvcName};


-- role excerpt_worker_user
grant select on excerpt_template to ${excerptWorkName};

grant select, update on excerpt_record to ${excerptWorkName};
