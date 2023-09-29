# Process Engine Deployment

Following values (application.properties) can be used to deploy MSR as Process Engine. 

## Prerequisites

You need an already created container image with ...
* Microservices Runtime
* External Database Drivers
* Process Engine (WmPRT package)
* Monitor (WmMonitor package)

To create an image, you should use the product codes `MSC,wmprt,PIEContainerExternalRDBMS,Monitor`.

The Process Engine requires following deployments minimal:
* Process Engine database
* Process Auditing database
* Archive database
* Universal Messaging

Optional, My webMethods Server regarding monitoring can be deployed. In this case, you must be deployed a Central Users database.

The Process Engine use the `microservicesruntime` Helm Chart. See [README](../../helm/README.md) to solve the prerequisites.

There are 2 possibilities to inject MSR application properties
* as YAML
* as plain text file `application.properties` 

## Create webMethods Database Components

Before starting MSR, the `wmdb` database must be filled with assets using Database Component Configurator (DCC). You can use the utility [image-builder-using-Azure-DevOps](../../../utils/image-builder-using-azure-devops/README.md) or [image-builder-dcc](../../../utils/image-builder-dcc/README.md) to build an image for DCC. After DCC image `wm-dcc:10.15` is created, use following Kubernetes `run` command to create the *product* components `IS` in `wm-msr-db`:

```shell
kubectl run wm-dcc-client --rm --tty -i --restart='Never' --image wm-dcc:10.15 --namespace msr --command -- /opt/softwareag/common/db/bin/dbConfigurator.sh -a CREATE -l "jdbc:wm:postgresql://wm-msr-db:5432;databaseName=wmdb" --dbms postgresql -u wm -p "manage" -pr IS,PRE
```

## Values (as YAML)

Following values are defined for Process Engine in [values.yaml](./values.yaml):

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| jobs[0] | object | `{"annotations":{"helm.sh/hook":"post-install","helm.sh/hook-delete-policy":"hook-succeeded","helm.sh/hook-weight":"0"},"args":["-c","echo Deploying Assets in UM [$UM_HOST] ...; runUMTool.sh CreateJMSTopic          -rname=$UM_URL -channelname=PEBroadcastTopic -synceachwrite=true runUMTool.sh CreateJMSTopic          -rname=$UM_URL -channelname=PERestartTopic   -synceachwrite=true"],"command":["/bin/bash"],"env":[{"name":"UM_URL","value":"{{ .Values.microservicesruntime.um.url }}"}],"image":{"repository":"sagcr.azurecr.io/universalmessaging-tools","tag":10.15},"imagePullPolicy":"IfNotPresent","name":"deploy-PE-assets-to-um","restartPolicy":"Never"}` | Create PE topics in UM on Helm post-install hook  |
| jobs[0].args | list | `["-c","echo Deploying Assets in UM [$UM_HOST] ...; runUMTool.sh CreateJMSTopic          -rname=$UM_URL -channelname=PEBroadcastTopic -synceachwrite=true runUMTool.sh CreateJMSTopic          -rname=$UM_URL -channelname=PERestartTopic   -synceachwrite=true"]` | Shell script to deploy / create assets in UM using runUMTool.sh |
| jobs[0].env[0] | object | `{"name":"UM_URL","value":"{{ .Values.microservicesruntime.um.url }}"}` | Environment variable for Shell script |
| jobs[0].env[0].value | string | `"{{ .Values.microservicesruntime.um.url }}"` | Set UM Realm URL from this file |
| microservicesruntime.mws.host | string | `nil` | Connect to My webMethods Server hostname |
| microservicesruntime.mws.password | string | `nil` | Connect to My webMethods Server Administrator password |
| microservicesruntime.properties.jdbc.archive.dbURL | string | `nil` | JDBC pool Archive database URL |
| microservicesruntime.properties.jdbc.archive.driverAlias | string | `"{{ .Values.microservicesruntime.properties.jdbc.pe.driverAlias }}"` | JDBC pool Archive database driver alias. Default is to use the Process Engine driver alias. |
| microservicesruntime.properties.jdbc.archive.password | string | `nil` | JDBC pool Archive database password |
| microservicesruntime.properties.jdbc.archive.userid | string | `nil` | JDBC pool Archive database user ID |
| microservicesruntime.properties.jdbc.cus.dbURL | string | `nil` | JDBC pool Central Users database URL |
| microservicesruntime.properties.jdbc.cus.driverAlias | string | `"{{ .Values.microservicesruntime.properties.jdbc.pe.driverAlias }}"` | JDBC pool Central Users database driver alias. Default is to use the Process Engine driver alias. |
| microservicesruntime.properties.jdbc.cus.password | string | `nil` | JDBC pool Central Users database password |
| microservicesruntime.properties.jdbc.cus.userid | string | `nil` | JDBC pool Central Users database user ID |
| microservicesruntime.properties.jdbc.pa.dbURL | string | `nil` | JDBC pool Process Audit database URL |
| microservicesruntime.properties.jdbc.pa.driverAlias | string | `"{{ .Values.microservicesruntime.properties.jdbc.pe.driverAlias }}"` | JDBC pool Process Audit database driver alias. Default is to use the Process Engine driver alias. |
| microservicesruntime.properties.jdbc.pa.maxConns | int | `10` | JDBC pool Process Audit database number of connections |
| microservicesruntime.properties.jdbc.pa.password | string | `nil` | JDBC pool Process Audit database password |
| microservicesruntime.properties.jdbc.pa.userid | string | `nil` | JDBC pool Process Audit database user ID |
| microservicesruntime.properties.jdbc.pe.dbURL | string | `nil` | JDBC pool Process Engine database URL |
| microservicesruntime.properties.jdbc.pe.driverAlias | string | `nil` | JDBC pool Process Engine database driver alias. To retrieve a list of available drivers, call GET `/admin/jdbc/driver` to running MSR. |
| microservicesruntime.properties.jdbc.pe.maxConns | int | `10` | JDBC pool Process Engine database number of connections |
| microservicesruntime.properties.jdbc.pe.password | string | `nil` | JDBC pool Process Engine database password |
| microservicesruntime.properties.jdbc.pe.userid | string | `nil` | JDBC pool Process Engine database user ID |
| microservicesruntime.properties.jdbcfunc.Archiving.connPoolAlias | string | `"archive"` | Assign JDBC pool `archiv` to Functions `Archiving` |
| microservicesruntime.properties.jdbcfunc.CentralUsers.connPoolAlias | string | `"cus"` | Assign JDBC pool `cus` to Functions `CentralUsers` |
| microservicesruntime.properties.jdbcfunc.DocumentHistory.connPoolAlias | string | `"pe"` | Assign JDBC pool `pe` to Functions `DocumentHistory` |
| microservicesruntime.properties.jdbcfunc.ISCoreAudit.connPoolAlias | string | `"pe"` | Assign JDBC pool `pe` to Functions `ISCoreAudit` |
| microservicesruntime.properties.jdbcfunc.ISDashboardStats.connPoolAlias | string | `"pe"` | Assign JDBC pool `pe` to Functions `ISDashboardStats` |
| microservicesruntime.properties.jdbcfunc.ISInternal.connPoolAlias | string | `"pe"` | Assign JDBC pool `pe` to Functions `ISInternal` |
| microservicesruntime.properties.jdbcfunc.ProcessAudit.connPoolAlias | string | `"pa"` | Assign JDBC pool `pa` to Functions `ProcessAudit` |
| microservicesruntime.properties.jdbcfunc.ProcessEngine.connPoolAlias | string | `"pe"` | Assign JDBC pool `pe` to Functions `ProcessEngine` |
| microservicesruntime.properties.jdbcfunc.Xref.connPoolAlias | string | `"pe"` | Assign JDBC pool `pe` to Functions `Xref` |
| microservicesruntime.properties.jms.DEFAULT_IS_JMS_CONNECTION.clientID | string | `"{{ .Release.Name }}"` | Set unique client ID |
| microservicesruntime.properties.jms.DEFAULT_IS_JMS_CONNECTION.csqSize | int | `0` | Enable/disable (csqSize=0) client site queuing (CSQ). Enable CSQ only with stateful set.           |
| microservicesruntime.properties.jms.DEFAULT_IS_JMS_CONNECTION.enabled | bool | `true` | Advice MSR container to enable connection |
| microservicesruntime.properties.jms.PE_NONTRANSACTIONAL_ALIAS.clientID | string | `"{{ .Release.Name }}"` | Set unique client ID |
| microservicesruntime.properties.jms.PE_NONTRANSACTIONAL_ALIAS.csqSize | int | `0` | Enable/disable (csqSize=0) client site queuing (CSQ). Enable CSQ only with stateful set.           |
| microservicesruntime.properties.jms.PE_NONTRANSACTIONAL_ALIAS.enabled | bool | `true` |  |
| microservicesruntime.properties.jndi.DEFAULT_IS_JNDI_PROVIDER.enabled | bool | `true` | Advice MSR container to enable connection |
| microservicesruntime.properties.jndi.DEFAULT_IS_JNDI_PROVIDER.providerURL | string | `"{{ .Values.microservicesruntime.um.url }}"` | Configure default JNDI provider UM URL |
| microservicesruntime.properties.messaging.IS_UM_CONNECTION.CLIENTPREFIX | string | `"{{ .Release.Name }}"` | Set unique client ID (/prefix) |
| microservicesruntime.properties.messaging.IS_UM_CONNECTION.default | bool | `true` | This is the DEFAULT connection |
| microservicesruntime.properties.messaging.IS_UM_CONNECTION.enableRequestReply | bool | `false` | Enable/disable Request/Reply queue. It is not needed. |
| microservicesruntime.properties.messaging.IS_UM_CONNECTION.enabled | bool | `true` | Advice MSR container to enable connection |
| microservicesruntime.properties.messaging.IS_UM_CONNECTION.type | string | `"UM"` |  |
| microservicesruntime.properties.messaging.IS_UM_CONNECTION.url | string | `"{{ .Values.microservicesruntime.um.url }}"` | wM messaging IS_UM_CONNECTION connects to UM URL |
| microservicesruntime.properties.messaging.IS_UM_CONNECTION.useCSQ | bool | `false` | Enable/disable client site queuing (CSQ). Enable CSQ only with stateful set. |
| microservicesruntime.properties.monproperty.wm.monitor | object | `{"myWebmethodsHost":"{{ .Values.microservicesruntime.mws.host }}","myWebmethodsPassword":"{{ .Values.microservicesruntime.mws.password }}","myWebmethodsPort":8585}` | See [Monitor](https://documentation.softwareag.com/webmethods/monitor/wmn10-15/webhelp/wmn-webhelp/index.html#page/wmn-webhelp%2Fre-configure_monitor_properties_msr_template.html) configuration settings  |
| microservicesruntime.properties.monproperty.wm.monitor.myWebmethodsHost | string | `"{{ .Values.microservicesruntime.mws.host }}"` | WmMonitor package connects to MWS hostname |
| microservicesruntime.properties.monproperty.wm.monitor.myWebmethodsPassword | string | `"{{ .Values.microservicesruntime.mws.password }}"` | WmMonitor package connects with MWS Adminitrator password |
| microservicesruntime.properties.monproperty.wm.monitor.myWebmethodsPort | int | `8585` | WmMonitor package connects to MWS port |
| microservicesruntime.properties.peproperty.watt.prt | object | `{"externalcluster":true,"optimizeBrokerURL":"{{ .Values.microservicesruntime.um.url }}","uploadMetadata":true}` | See [Process Engine](https://documentation.softwareag.com/webmethods/process_engine/wpe10-15/webhelp/wpe-webhelp/index.html#page/wpe-webhelp%2Fto-configuring_monitoring_8.html) configuration settings  |
| microservicesruntime.properties.peproperty.watt.prt.externalcluster | bool | `true` | Process Engine is running as external Cluster |
| microservicesruntime.properties.peproperty.watt.prt.optimizeBrokerURL | string | `"{{ .Values.microservicesruntime.um.url }}"` | Process Engine connect to UM URL |
| microservicesruntime.properties.peproperty.watt.prt.uploadMetadata | bool | `true` | Push BPM models to database |
| microservicesruntime.properties.settings.watt.net.localhost | string | `"{{ include \"common.names.fullname\" . }}"` | Set hostname of this MSR deployment |
| microservicesruntime.properties.settings.watt.server.audit.logFilesToKeep | int | `1` | Number of days to audit log files |
| microservicesruntime.properties.settings.watt.server.scheduler.logical.hostname | string | `"{{ include \"common.names.fullname\" . }}"` | Set hostname of this MSR deployment |
| microservicesruntime.properties.settings.watt.server.serverlogFilesToKeep | int | `1` | Number of days to keep server log files |
| microservicesruntime.properties.settings.watt.server.stats.logFilesToKeep | int | `1` | Number of days to statistic log files |
| microservicesruntime.properties.settings.watt.server.threadPool | int | `750` | Maximum number of available server threads  |
| microservicesruntime.properties.statisticsdatacollector.monitorConfig.enabled | bool | `false` | Enable or disable IS internal statistic data collector. (Statistic data are visible on Monitor page.) We disable statistic data collector because of using Grafana and Prometheus. |
| microservicesruntime.um.url | string | `nil` | Universal Messaging (UM) connection URL, e.g. nsp://my-um-realm:9000 |
## Values (as plain text)

Add following properties as text in value `applicationFile.properties`:

```
jdbc.archive.dbURL=
jdbc.archive.driverAlias=
jdbc.archive.password=
jdbc.archive.userid=
jdbc.cus.dbURL=
jdbc.cus.driverAlias=
jdbc.cus.password=
jdbc.cus.userid=
jdbc.pa.dbURL=
jdbc.pa.driverAlias=
jdbc.pa.maxConns=10
jdbc.pa.password=
jdbc.pa.userid=
jdbc.pe.dbURL=
jdbc.pe.driverAlias=
jdbc.pe.maxConns=10
jdbc.pe.password=
jdbc.pe.userid=
jdbcfunc.Archiving.connPoolAlias=archive
jdbcfunc.CentralUsers.connPoolAlias=cus
jdbcfunc.DocumentHistory.connPoolAlias=pe
jdbcfunc.ISCoreAudit.connPoolAlias=pe
jdbcfunc.ISDashboardStats.connPoolAlias=pe
jdbcfunc.ISInternal.connPoolAlias=pe
jdbcfunc.ProcessAudit.connPoolAlias=pa
jdbcfunc.ProcessEngine.connPoolAlias=pe
jdbcfunc.Xref.connPoolAlias=pe
jms.DEFAULT_IS_JMS_CONNECTION.clientID=
jms.DEFAULT_IS_JMS_CONNECTION.csqSize=0
jms.DEFAULT_IS_JMS_CONNECTION.enabled=true
jms.PE_NONTRANSACTIONAL_ALIAS.clientID=
jms.PE_NONTRANSACTIONAL_ALIAS.csqSize=0
jms.PE_NONTRANSACTIONAL_ALIAS.enabled=true
jndi.DEFAULT_IS_JNDI_PROVIDER.enabled=true
jndi.DEFAULT_IS_JNDI_PROVIDER.providerURL=
messaging.IS_UM_CONNECTION.CLIENTPREFIX=
messaging.IS_UM_CONNECTION.default=true
messaging.IS_UM_CONNECTION.enableRequestReply=false
messaging.IS_UM_CONNECTION.enabled=true
messaging.IS_UM_CONNECTION.type=UM
messaging.IS_UM_CONNECTION.url=
messaging.IS_UM_CONNECTION.useCSQ=false
monproperty.wm.monitor.myWebmethodsHost=
monproperty.wm.monitor.myWebmethodsPassword=
monproperty.wm.monitor.myWebmethodsPort=8585
peproperty.watt.prt.externalcluster=true
peproperty.watt.prt.optimizeBrokerURL=
peproperty.watt.prt.uploadMetadata=true
settings.watt.net.localhost=
settings.watt.server.scheduler.logical.hostname=
settings.watt.server.serverlogFilesToKeep=1
settings.watt.server.stats.logFilesToKeep=1
settings.watt.server.audit.logFilesToKeep=1
settings.watt.server.threadPool=750
statisticsdatacollector.monitorConfig.enabled=false
```


