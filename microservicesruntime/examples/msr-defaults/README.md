# Recommended default MSR Settings

Running MSR as container, you should go throw the following `application.properties` settings and copy/past these to your configuration (values.yaml).

```
# Set Administrator password ...
user.Administrator.password=

# Set Pod host/container name (following sample retrieves the hostname from Helm Chart) ...
settings.watt.net.localhost="{{ include \"common.names.fullname\" . }}"
settings.watt.server.scheduler.logical.hostname=="{{ include \"common.names.fullname\" . }}"

# Avoid creating backup files for config changes ...
settings.watt.server.saveConfigFiles=false 

# Avoid archiving audit log files ...
settings.watt.server.audit.logFilesToKeep=1

# Avoid archiving server log files ...
settings.watt.server.serverlogFilesToKeep=1

# Avoid archiving statistic files ...
settings.watt.server.stats.logFilesToKeep=1

# Value for 1 to 9 to set debug level of server log ...
# settings.watt.debug.level=

# Avoid saving/restore pipeline settings in service ...
settings.watt.server.pipeline.processor=false

# Set the maximum number of permitted service threads in the global pool ...
settings.watt.server.threadPool=750

# Set the default response type if Accept header missing in outbound http calls ...
settings.watt.net.default.accept=json

# Set the default response behavior on error ...
settings.watt.server.http.returnException=messageOnly

# Set the default request/response content-type ...
settings.watt.net.default.content-type=json

# Avoid IS internal statistic data collector ...
statisticsdatacollector.monitorConfig.enabled=false

# If you have stateless MSR and default UM wM messaging connection IS_UM_CONNECTION, disable CSQ (to reduce risk of data loss) and RequestReply queues ...
messaging.IS_UM_CONNECTION.CLIENTPREFIX=
messaging.IS_UM_CONNECTION.default=true
messaging.IS_UM_CONNECTION.enableRequestReply=false
messaging.IS_UM_CONNECTION.enabled=true
messaging.IS_UM_CONNECTION.type=UM
messaging.IS_UM_CONNECTION.url=
messaging.IS_UM_CONNECTION.useCSQ=false

# If you have stateless MSR and default UM JMS connection DEFAULT_IS_JMS_CONNECTION, disable CSQ (to reduce risk of data loss) ...
jms.DEFAULT_IS_JMS_CONNECTION.clientID=
jms.DEFAULT_IS_JMS_CONNECTION.csqSize=0
jms.DEFAULT_IS_JMS_CONNECTION.enabled=true
```
