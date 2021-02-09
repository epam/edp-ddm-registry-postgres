--liquibase formatted sql
--changeset platform:create-notifications-roles context:"pub"
--validCheckSum: ANY
-- role notification_template_publisher_user
create role ${notificationTemplatePublisherName} with password '${notificationTemplatePublisherPass}' login;
-- role notification_service_user
create role ${notificationServiceName} with password '${notificationServicePass}' login;

--changeset platform:create-notifications-db runInTransaction:false context:"pub"
create database notifications;