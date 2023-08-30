# Service Auditing Monitor Deployment

Following values (application.properties) can be used to deploy MSR as Service Auditing Monitor instead of using My webMethods Server. The running container allows your to monitor and to resubmit services using the WmMonitor package. Furthermore, a job regarding archiving of auditing data is provided.

## Prerequisites

You need an already created container image with ...
* Microservices Runtime
* External Database Drivers
* Monitor (WmMonitor package)

To create an image, you should use the product codes `MSC,PIEContainerExternalRDBMS,Monitor`.

The Service Auditing Monitor requires following deployments minimal:
* IS database 
* Archive database

The Service Auditing Monitor use the `microservicesruntime` Helm Chart. See [README](../../helm/README.md) to solve the prerequisites.

Unfortunately, If you want to use a Kubernetes cron job to archive the auditing data, you must deploy a [My webMethods Server](../../../mywebmethodsserver/helm/README.md) and configure WmMonitor package. The configuration of WmMonitor will be provided in *Values* section.

## Values

[values.yaml](./values.yaml) contains values to start MSR as Service Auditing Monitor.

## A Job for Archiving Configuration

[values-archiving-config-job.yaml](./values-archiving-config-job.yaml) contains values to start with Kubernetes job the configuration settings for archiving jobs. The archiving database must point to the auditing database. The Job use the services [pub.monitor.archive:setOperationParameters](https://documentation.softwareag.com/webmethods/monitor/wmn10-15/webhelp/wmn-webhelp/index.html#page/wmn-webhelp%2Fto-archive_folder_10.html%23wwconnect_header) to configure the setting. The following example is for PostgresQL that the archiving database find the IS database in `public` schema.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| jobs[0].annotations."helm.sh/hook" | string | `"post-install,post-upgrade"` | Start the job per Helm hook on `post-install` or `post-upgrade` |
| jobs[0].annotations."helm.sh/hook-delete-policy" | string | `"hook-succeeded"` |  |
| jobs[0].annotations."helm.sh/hook-weight" | string | `"0"` |  |
| jobs[0].args[0] | string | `"-c"` |  |
| jobs[0].args[1] | string | `"echo Configure Archiving with [${DEPLOYMENT}] ...; apt-get update; apt-get install jq   -y; apt-get install curl -y; status=$(curl -s -o /dev/null -w \"%{http_code}\" ${DEPLOYMENT}:5555 -u \"Administrator:${ADMIN_PASSWORD}\"); while [[ \"${status}\" != \"200\" ]]; do \n  echo Waiting for IS [${DEPLOYMENT}] status [${status}] ...;\n  sleep 10;\n  status=$(curl -s -o /dev/null -w \"%{http_code}\" ${DEPLOYMENT}:5555 -u \"Administrator:${ADMIN_PASSWORD}\");\ndone; curl -s -u \"Administrator:${ADMIN_PASSWORD}\" -H \"Content-Type: application/json\" \"${DEPLOYMENT}:5555/invoke/pub.monitor.archive:setOperationParameters?ISCORE_SCHEMA=public&PROCESS_SCHEMA=public\" | jq '.';"` |  |
| jobs[0].command[0] | string | `"/bin/bash"` |  |
| jobs[0].envFrom[0].secretRef.name | string | `"msr-secrets"` |  |
| jobs[0].image.repository | string | `"ubuntu"` |  |
| jobs[0].image.tag | string | `"latest"` |  |
| jobs[0].imagePullPolicy | string | `"IfNotPresent"` |  |
| jobs[0].name | string | `"configure-archiving"` |  |
| jobs[0].restartPolicy | string | `"Never"` |  |

## A Cron Job for Archiving

[values-archiving-config-job.yaml](./values-archiving-config-job.yaml) contains values to start with Kubernetes cron job the archiving of auditing data. The job calls the [archiving APIs of WmMonitor packages](https://documentation.softwareag.com/webmethods/monitor/wmn10-15/webhelp/wmn-webhelp/index.html#page/wmn-webhelp%2Fto-archive_folder.html%23)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| jobs[0] | object | `{"args":["-c","echo Archiving Auditing data with [${DEPLOYMENT}] ...;       apt-get update; apt-get install jq   -y; apt-get install curl -y; echo \"Archiving Server data ...\" curl -s -u \"Administrator:${ADMIN_PASSWORD}\" -H \"Content-Type: application/json\" \"${DEPLOYMENT}:5555/invoke/pub.monitor.archive:serverArchive?days=30&archiveAction=DELETE&batchSize=100\" | jq '.'; echo \"Archiving Process data ...\" curl -s -u \"Administrator:${ADMIN_PASSWORD}\" -H \"Content-Type: application/json\" \"${DEPLOYMENT}:5555/invoke/pub.monitor.archive:processArchive?days=30&archiveAction=DELETE&batchSize=100&status=COMPLETED-FAILED\" | jq '.'; echo \"Archiving Services data ...\" curl -s -u \"Administrator:${ADMIN_PASSWORD}\" -H \"Content-Type: application/json\" \"${DEPLOYMENT}:5555/invoke/pub.monitor.archive:serviceArchive?days=30&archiveAction=DELETE&batchSize=100&status=COMPLETED-FAILED\" | jq '.';"],"command":["/bin/bash"],"envFrom":[{"secretRef":{"name":"msr-secrets"}}],"image":{"repository":"ubuntu","tag":"latest"},"imagePullPolicy":"IfNotPresent","name":"archive-auditing-data","restartPolicy":"Never","schedule":"* * * * *"}` | Implements a cron job to purge all auditing data which are older than 30 days. |
| jobs[0].schedule | string | `"* * * * *"` | Schedule job every |



