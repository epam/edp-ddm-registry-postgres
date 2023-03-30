# platform-db
Liquibase scripts for platform dbs and objects
## Folder structure
```bash
platform-db
├── changesets                        # ──> Home for all changesets.
│   ├── audit                         # ┬─> Folders containing sql changesets for each database.
│   ├── excerpt                       # │
│   ├── notifications                 # │
│   ├── postgres                      # │
│   ├── registry                      # │
│   ├── settings                      # ┘
│   ├── audit-changelog.xml           # ┬─> Changelog files for each database. Include all the sql files from the respective folders.
│   ├── excerpt-changelog.xml         # │
│   ├── notifications-changelog.xml   # │
│   ├── postgres-changelog.xml        # │
│   ├── registry-changelog.xml        # │
│   ├── settings-changelog.xml        # ┘
│   ├── worker-postgres-changelog.xml # ┬─> Changelogs for workers.
│   └── worker-registry-changelog.xml # ┘
├── run_local.sh                      # ──> Runs update on local registry-postgres. For testing.
└── update.sh                         # ──> Run lb update on all DBs in order.
```
## General rules
XML chanlogs files generally do not need to be edited. They automatically pick up all the new sql files put into `<database name>` folders.

*Database folder structure*
```bash
registry
├── procedures
│   ├── f_check_permissions_dcm.sql
│   ├── ....................
│   └── p_version_control.sql
├── triggers
├── views
├── z-post-update
├── 00010_init-db.sql
├── .................
├── 00080_subscription.sql
└── .................
```
### Procedures, views and triggers
All procedures, views and triggers go into the respective folders in the database folder. Files name is the same as the func/view/trigger name.

The file must start with the following comment
```sql
--liquibase formatted sql
--changeset platform:<func/view/trigger name> splitStatements:false stripComments:false runOnChange:true
```
Example - [f_check_permissions_dcm.sql](../platform-db/changesets/registry/procedures/f_check_permissions_dcm.sql)

These files can be edited. Liquibase keeps track of the changes and runs the scripts only if they are changed compared to the previous deployment.

### z-post-update folder
This folder contains scripts that will be run the last.
Look below about file names' convention and file starting lines.

### Everithing else
Everithing else goes into database folder root. The script can contain any sql statements.

File name must follow the convention

> *XXXX0_descriptive-name.sql*

Where *XXXX* is the number next in sequence after the last sql changeset in the folder.

The file must start with the following comment
```sql
--liquibase formatted sql
--changeset platform:<descriptive unique id>
```
Example - [00050_create-types.sql](../platform-db/changesets/registry/00050_create-types.sql)

These files can NOT be edited. Liquibase makes sure that these files are executed on the target database only once and in order.
## More details on SQL Based changesets
Formatted SQL files use comments to provide Liquibase with metadata. Each SQL file must begin with the following comment:
```sql
--liquibase formatted sql
```
Each changeset in a formatted SQL file begins with a comment of the form:
```sql
--changeset author:id attribute1:value1 attribute2:value2 [...]
```
The changeset comment is followed by one or more SQL statements

For example
```sql
--liquibase formatted sql
--changeset platform:create-types
CREATE TYPE type_operation AS ENUM ('S','I','U','D');
CREATE TYPE type_dml AS ENUM ('I','U','D');
```
### changelog Property Substitution

Liquibase allows a dynamic substitution of properties in your changelog. The tokens to replace in your changelog are described using the ${property-name} syntax.

Example - [00010_init-db.sql](../platform-db/changesets/registry/00010_init-db.sql)
### Changeset attributes
#### context:"sub" or context:"pub"
Executes the change if the particular context was passed at runtime. We use it only for the **registry** and **postgres** DBs. There are three options: 
* no context - run on both master and replica
* context:"pub" - run only on master
* context:"sub" - run only on replica

All other DBs scripts executed only on master

Example [00040_create-other-roles.sql](../platform-db/changesets/postgres/00040_create-other-roles.sql)
#### runOnChange:true
Executes the change the first time it is seen and each time the changeset has been changed. We use it for procedures, views and triggers.
#### runInTransaction:false
Specifies whether the changeset can be run as a single transaction. We use it for statements that cannot be run in transaction, such as ```create database``` or ```create subscription```

Example - [00060_create-registry.sql](../platform-db/changesets/postgres/00060_create-registry.sql)
#### splitStatements:false 
Removes Liquibase split statements on ;'s and GO's when it is set to false. We use it for procedures and anonimous PL/pgSQL blocks

Example - [00020_register-workers.sql](../platform-db/changesets/registry/00020_register-workers.sql)
#### stripComments:false
Removes any comments in the SQL before executing when it is set to true. Used for procedures, views and triggers to preserve comments. 
#### --validCheckSum: ANY
Valid checksum is a checksum which is valid for a specific changeset, regardless of what is stored in the database. We use it when we have passwords or something else that can change between deployments in the parameters substitution.

Because liquibase computes the check sum after the parameter substitution it can fail the check if parameter is changed. **ANY** makes liquibase skip checksum check. 

Example - [00010_create-audit.sql](../platform-db/changesets/postgres/00010_create-audit.sql)
### Learn more at [changelogs in SQL Format](https://docs.liquibase.com/concepts/basic/sql-format.html)
