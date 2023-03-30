# registry-postgres

### Overview
Templates for deployment Postgres instances with registry-postgres extension and Liquibase scripts for platform DBs and objects.

### Usage
Use this repository for deployment Postgres instances with registry-postgres extension and for deployment platform DBs and objects.
See [platform-db/README.md](platform-db/README.md) about Liquibase scripts for platform DBs and objects.

### Local development

###### Prerequisites
Kubernetis cluster.

###### Steps
To deploy execute the command below:
```bash
helm upgrade --install registry-postgres --namespace <your-namespace>
```

### Licensing
The registry-postgres is Open Source software released under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0).
