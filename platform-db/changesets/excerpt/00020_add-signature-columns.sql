--liquibase formatted sql
--changeset platform:add-signature-columns
ALTER TABLE excerpt_record
    ADD COLUMN x_digital_signature text null,
    ADD COLUMN x_digital_signature_derived text null;