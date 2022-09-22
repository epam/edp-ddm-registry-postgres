#!/bin/bash -ev
lb_params="--logLevel=info --databaseChangeLogTableName=ddm_db_changelog --databaseChangeLogLockTableName=ddm_db_changelog_lock"
reg_path="currentSchema=public,registry"
#Master platform
liquibase --contexts="pub" $lb_params --changeLogFile=changesets/postgres-changelog.xml \
    --username=$DB_NAME_OP --password=$DB_PASS_OP --url=$masterDBurl/postgres update
liquibase $lb_params --changeLogFile=changesets/audit-changelog.xml \
    --username=$DB_NAME_OP --password=$DB_PASS_OP --url=$masterDBurl/audit update
liquibase $lb_params --changeLogFile=changesets/settings-changelog.xml \
    --username=$DB_NAME_OP --password=$DB_PASS_OP --url=$masterDBurl/settings update
liquibase $lb_params --changeLogFile=changesets/excerpt-changelog.xml \
    --username=$DB_NAME_OP --password=$DB_PASS_OP --url=$masterDBurl/excerpt update
liquibase $lb_params --changeLogFile=changesets/process_history-changelog.xml \
    --username=$DB_NAME_OP --password=$DB_PASS_OP --url=$masterDBurl/process_history update
liquibase $lb_params --changeLogFile=changesets/notifications-changelog.xml \
    --username=$DB_NAME_OP --password=$DB_PASS_OP --url=$masterDBurl/notifications update
liquibase $lb_params --changeLogFile=changesets/camunda-changelog.xml \
    --username=$DB_NAME_OP --password=$DB_PASS_OP --url=$masterDBurl/camunda update
#Replica platform
liquibase --contexts="sub" $lb_params --changeLogFile=changesets/postgres-changelog.xml \
    --username=$DB_NAME_AN --password=$DB_PASS_AN --url=$replicaDBurl/postgres update
#Master Registry
liquibase --contexts="pub" $lb_params --changeLogFile=changesets/registry-changelog.xml \
    --username=$DB_NAME_OP --password=$DB_PASS_OP --url=$masterDBurl/$dbName?$reg_path update
#Replica Registry
liquibase --contexts="sub" $lb_params --changeLogFile=changesets/registry-changelog.xml \
    --username=$DB_NAME_AN --password=$DB_PASS_AN --url=$replicaDBurl/$dbName?$reg_path update
#Master registry-template
liquibase --contexts="pub,template" $lb_params --changeLogFile=changesets/registry-changelog.xml \
    --username=$DB_NAME_OP --password=$DB_PASS_OP --url=$masterDBurl/registry_template?$reg_path update
