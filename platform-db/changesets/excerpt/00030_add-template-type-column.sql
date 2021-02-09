--liquibase formatted sql
--changeset platform:add-template-type-column
ALTER TABLE excerpt_template ADD COLUMN template_type text not null default 'pdf';
ALTER TABLE excerpt_template ALTER COLUMN template_type drop default;
ALTER TABLE excerpt_record ADD COLUMN excerpt_type text not null default 'pdf';
ALTER TABLE excerpt_record ALTER COLUMN excerpt_type drop default;