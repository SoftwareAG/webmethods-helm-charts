# Deployment with external PostgreQL Database

Following values (application.properties) can be used to deploy MSR with connection to external PostgreQL database.

## Prerequisites

Additional to [Microservices Runtime Prerequisites](../../helm/README.md), you need an already created container image with ...
* Microservices Runtime
* External Database Drivers

To create an image, you should use the product codes `MSC,PIEContainerExternalRDBMS`.

See *Deploy a PostgresQL* to create database if don't have such.

## Deploy a PostgresQL

Create a PostgresQL database ...

```shell
helm repo add bitnami https://charts.bitnami.com/bitnami

helm install wm-mws-db bitnami/postgresql --namespace msr \
  --set global.postgresql.auth.postgresPassword=manage    \
  --set global.postgresql.auth.username=wm                \
  --set global.postgresql.auth.password=manage            \
  --set global.postgresql.auth.database=wmdb              \
  --set primary.persistence.size=100M
```

## Create webMethods Database Components

Before starting MSR, the `wmdb` database must be filled with assets using Database Component Configurator (DCC). See GitHub project [webMethods Image Creator](https://github.softwareag.com/PS/pswm-inno-container-image-creator) to create an image for DCC. After DCC image `wm-dcc:10.15` is created, use following Kubernetes `run` command to create the *product* components `IS` in `wm-mws-db`:

```shell
kubectl run wm-dcc-client --rm --tty -i --restart='Never' --image wm-dcc:10.15 --namespace msr --command -- /opt/softwareag/common/db/bin/dbConfigurator.sh -a CREATE -l "jdbc:wm:postgresql://wm-msr-db:5432;databaseName=wmdb" --dbms postgresql -u wm -p "manage" -pr IS
```

## Values

Following values are provided in [values.yaml](./values.yaml).

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| microservicesruntime.properties.jdbc.data.dbURL | string | `"jdbc:wm:postgresql://wm-msr-db-postgresql:5432;databaseName=wmdb"` | JDBC pool Process Engine database URL |
| microservicesruntime.properties.jdbc.data.driverAlias | string | `"DataDirect Connect JDBC PostgreSQL Driver"` | JDBC pool Process Engine database driver alias. To retrieve a list of available drivers, call GET `/admin/jdbc/driver` to running MSR. |
| microservicesruntime.properties.jdbc.data.maxConns | int | `10` | JDBC pool Process Engine database number of connections |
| microservicesruntime.properties.jdbc.data.password | string | `"manage"` | JDBC pool Process Engine database password |
| microservicesruntime.properties.jdbc.data.userid | string | `"wm"` | JDBC pool Process Engine database user ID |
| microservicesruntime.properties.jdbcfunc.DocumentHistory.connPoolAlias | string | `"data"` | Assign JDBC pool `pe` to Functions `DocumentHistory` |
| microservicesruntime.properties.jdbcfunc.ISCoreAudit.connPoolAlias | string | `"data"` | Assign JDBC pool `pe` to Functions `ISCoreAudit` |
| microservicesruntime.properties.jdbcfunc.ISDashboardStats.connPoolAlias | string | `"data"` | Assign JDBC pool `pe` to Functions `ISDashboardStats` |
| microservicesruntime.properties.jdbcfunc.ISInternal.connPoolAlias | string | `"data"` | Assign JDBC pool `pe` to Functions `ISInternal` |
| microservicesruntime.properties.jdbcfunc.ProcessAudit.connPoolAlias | string | `"data"` | Assign JDBC pool `pa` to Functions `ProcessAudit` |
| microservicesruntime.properties.jdbcfunc.ProcessEngine.connPoolAlias | string | `"data"` | Assign JDBC pool `pe` to Functions `ProcessEngine` |
| microservicesruntime.properties.jdbcfunc.Xref.connPoolAlias | string | `"data"` | Assign JDBC pool `pe` to Functions `Xref` |
| microservicesruntime.properties.settings.watt.net.localhost | string | `"{{ include \"microservicesruntime.fullname\" . }}"` | Set hostname of this MSR deployment |
| microservicesruntime.properties.settings.watt.server.scheduler.logical.hostname | string | `"{{ include \"microservicesruntime.fullname\" . }}"` | Set hostname of this MSR deployment |
| microservicesruntime.properties.settings.watt.server.serverlogFilesToKeep | int | `1` | Number of days to keep server log files |
| microservicesruntime.properties.settings.watt.server.stats.logFilesToKeep | int | `1` | Number of days to statistic log files |
| microservicesruntime.properties.settings.watt.server.threadPool | int | `750` | Maximum number of available server threads  |
| microservicesruntime.properties.statisticsdatacollector.monitorConfig.enabled | bool | `false` | Enable or disable IS internal statistic data collector. (Statistic data are visible on Monitor page.) We disable statistic data collector because of using Grafana and Prometheus. |
