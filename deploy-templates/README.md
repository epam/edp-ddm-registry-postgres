# registry-postgres

![Version: 0.3.0](https://img.shields.io/badge/Version-0.3.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 5.1.0](https://img.shields.io/badge/AppVersion-5.1.0-informational?style=flat-square)

Helm chart with custom resources for Postgres clusters deploying using the open source Postgres Operator from Crunchy Data

**Homepage:** <OSS-DDM>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| oss-ddm |  |  |

## Source Code

* <https://github.com/epam/edp-ddm-registry-postgres>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cdPipelineName | string | `""` |  |
| cdPipelineStageName | string | `""` |  |
| database.required | bool | `false` |  |
| database.timezone | string | `"UTC"` |  |
| dnsWildcard | string | `"apps.cicd.mdtu-ddm.projects.epam.com"` |  |
| global.container.requestsLimitsEnabled | bool | `true` |  |
| global.crunchyPostgres.backups.pgbackrest.repos.schedules.full | string | `"0 1 * * *"` |  |
| global.crunchyPostgres.postgresql.parameters.max_connections | int | `200` |  |
| global.crunchyPostgres.storageSize | string | `"10Gi"` |  |
| global.crunchyPostgresOperator.instances.analytical.name | string | `"instance1"` |  |
| global.crunchyPostgresOperator.instances.analytical.replicas | int | `1` |  |
| global.crunchyPostgresOperator.instances.operational.name | string | `"instance1"` |  |
| global.crunchyPostgresOperator.instances.operational.replicas | int | `1` |  |
| global.crunchyPostgresOperator.minioConf.bucketName | string | `""` |  |
| global.imageRegistry | string | `"defaultValue"` |  |
| global.registry.analyticalInstance.container.resources.limits | object | `{}` |  |
| global.registry.analyticalInstance.container.resources.requests | object | `{}` |  |
| global.registry.operationalInstance.container.resources.limits | object | `{}` |  |
| global.registry.operationalInstance.container.resources.requests | object | `{}` |  |
| global.registry.operationalPool.container.resources.limits | object | `{}` |  |
| global.registry.operationalPool.container.resources.requests | object | `{}` |  |
| global.storageClass | string | `"gp2"` |  |
| image.name | string | `"citus-chart"` |  |
| image.version | string | `"latest"` |  |
| manageRedashConfigmapName | string | `"manage-redash-viewer-db-roles-configmap"` |  |
| name | string | `"registry-postgres"` |  |
| namespace | string | `""` |  |
| pgpool.image.name | string | `"pgpool/pgpool"` |  |
| pgpool.image.version | string | `"4.4.3"` |  |
| postgresCluster.analyticalClusterSecret.name | string | `"analytical-pguser-postgres"` |  |
| postgresCluster.archiveSchema | string | `"archive"` |  |
| postgresCluster.backups.pgbackrest.global.log-level-file | string | `"detail"` |  |
| postgresCluster.backups.pgbackrest.global.repo1-retention-full | string | `"1"` |  |
| postgresCluster.backups.pgbackrest.global.repo1-retention-full-type | string | `"count"` |  |
| postgresCluster.backups.pgbackrest.global.repo1-s3-uri-style | string | `"path"` |  |
| postgresCluster.backups.pgbackrest.global.repo1-storage-port | string | `"443"` |  |
| postgresCluster.backups.pgbackrest.global.repo1-storage-verify-tls | string | `"n"` |  |
| postgresCluster.backups.pgbackrest.global.start-fast | string | `"y"` |  |
| postgresCluster.backups.pgbackrest.repos.name | string | `"repo1"` |  |
| postgresCluster.cronJob.image | string | `"bitnami/postgresql:14"` |  |
| postgresCluster.cronJob.interval | int | `3` |  |
| postgresCluster.cronJob.name | string | `"operational-audit-clean"` |  |
| postgresCluster.cronJob.schedule | string | `"30 0 * * *"` |  |
| postgresCluster.dbName | string | `"registry"` |  |
| postgresCluster.image.name | string | `"crunchydata/crunchy-postgres-gis"` |  |
| postgresCluster.image.version | string | `"ubi8-14.3-3.2-0"` |  |
| postgresCluster.initContainer.image | string | `"busybox"` |  |
| postgresCluster.jobName | string | `"run-db-scripts-job"` |  |
| postgresCluster.minioSecretName | string | `"s3-conf"` |  |
| postgresCluster.operationalClusterSecret.name | string | `"operational-pguser-postgres"` |  |
| postgresCluster.pgbackrest.image.name | string | `"crunchydata/crunchy-pgbackrest"` |  |
| postgresCluster.pgbackrest.image.version | string | `"ubi8-2.38-1"` |  |
| postgresCluster.pgmonitor.exporter.image.name | string | `"crunchydata/crunchy-postgres-exporter"` |  |
| postgresCluster.pgmonitor.exporter.image.version | string | `"ubi8-5.2.0-0"` |  |
| postgresCluster.pgmonitor.podMonitorName | string | `"crunchy-postgres-exporter"` |  |
| postgresCluster.port | int | `5432` |  |
| postgresCluster.postgresVersion | int | `14` |  |
| postgresCluster.postgresql.parameters.log_destination | string | `"stderr"` |  |
| postgresCluster.postgresql.parameters.log_min_duration_statement | int | `1000` |  |
| postgresCluster.postgresql.parameters.logging_collector | string | `"off"` |  |
| postgresCluster.postgresql.parameters.password_encryption | string | `"md5"` |  |
| postgresCluster.postgresql.parameters.synchronous_standby_names | string | `"*"` |  |
| postgresCluster.pubHost | string | `"operational-primary"` |  |
| postgresCluster.pubPort | int | `5432` |  |
| postgresCluster.pubUser | string | `"postgres"` |  |
| postgresCluster.region | string | `"eu-central-1"` |  |
| postgresCluster.secrets.citusRolesSecrets.admRole | string | `"admin_role"` |  |
| postgresCluster.secrets.citusRolesSecrets.anAdm | string | `"analytics_admin"` |  |
| postgresCluster.secrets.citusRolesSecrets.anRole | string | `"analytics_auditor"` |  |
| postgresCluster.secrets.citusRolesSecrets.anSvc | string | `"audit_service_user"` |  |
| postgresCluster.secrets.citusRolesSecrets.appRole | string | `"application_role"` |  |
| postgresCluster.secrets.citusRolesSecrets.bpAdminPortalService | string | `"bp_admin_portal_service_user"` |  |
| postgresCluster.secrets.citusRolesSecrets.bpmService | string | `"bpm_service_user"` |  |
| postgresCluster.secrets.citusRolesSecrets.excerptExporter | string | `"excerpt_exporter"` |  |
| postgresCluster.secrets.citusRolesSecrets.excerptSvc | string | `"excerpt_service_user"` |  |
| postgresCluster.secrets.citusRolesSecrets.excerptWork | string | `"excerpt_worker_user"` |  |
| postgresCluster.secrets.citusRolesSecrets.geoserverRole | string | `"geoserver_role"` |  |
| postgresCluster.secrets.citusRolesSecrets.histRole | string | `"historical_data_role"` |  |
| postgresCluster.secrets.citusRolesSecrets.notificationService | string | `"notification_service_user"` |  |
| postgresCluster.secrets.citusRolesSecrets.notificationTemplatePublisher | string | `"notification_template_publisher_user"` |  |
| postgresCluster.secrets.citusRolesSecrets.processHistoryRole | string | `"process_history_role"` |  |
| postgresCluster.secrets.citusRolesSecrets.redashAdminRole | string | `"redash_admin_role"` |  |
| postgresCluster.secrets.citusRolesSecrets.regOwner | string | `"registry_owner_role"` |  |
| postgresCluster.secrets.citusRolesSecrets.regRegulationRole | string | `"registry_regulation_management_role"` |  |
| postgresCluster.secrets.citusRolesSecrets.regTemplateOwner | string | `"registry_template_owner_role"` |  |
| postgresCluster.secrets.citusRolesSecrets.settRole | string | `"settings_role"` |  |
| postgresCluster.secrets.citusSecrets.pgsecretKey | string | `"password"` |  |
| postgresCluster.secrets.citusSecrets.pgsecretName | string | `"citus-secrets"` |  |
| postgresCluster.secrets.citusSecrets.rolesSecret | string | `"citus-roles-secrets"` |  |
| postgresCluster.secrets.citusSecrets.userName | string | `"username"` |  |
| postgresCluster.securityContext.fsGroup | int | `999` |  |
| postgresCluster.securityContext.runAsUser | int | `999` |  |
| postgresCluster.serviceAccountName | string | `"registry-postgres"` |  |
| postgresCluster.url.masterDBurl | string | `"jdbc:postgresql://operational-primary:5432"` |  |
| postgresCluster.url.replicaDBurl | string | `"jdbc:postgresql://analytical-primary:5432"` |  |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.memory | string | `"1Gi"` |  |