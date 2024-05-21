# Deployment with *Post-Init* Action 

This example and use-case shows how to perform post initialize actions after the startup has been performed. *Post-init* is mainly used to perform actions like database upgrades or (like in this case) deploy assets to Universal Messaging (UM).

This use-case is similar to [msr-push-doc-types](../msr-push-doc-types/README.md). It uses the Helm `post-install` and `post-upgrade` and creates a Kubernetes job at creation time of one of the events.

## Prerequisites

This deployment depends on Universal Messaging. Make sure that UM is up and running before deploying this MSR example.

## Job Template and `DEPLOYMENT` Environment Variable

The [Job template](../../helm/templates/job.yaml) is used to create a Kubernetes (Cron) Job object. A feature of this template is to set the environment variable `DEPLOYMENT` with the full deployment name. The deployment name is equal to the Kubernetes service name.

## Values

Following [values](./values-deploy-assets-to-um.yaml) create a Kubernetes job to deploy UM assets. The `sagcr.azurecr.io/universalmessaging-tools:10.15` image from [containers registry](https://containers.softwareag.com) is used to create JNDI connection factory. Inside the container, the tool [runUMTool.sh](https://documentation.softwareag.com/universal_messaging/num10-15/webhelp/num-webhelp/index.html#page/num-webhelp%2Fco-clu_standard_administration_tasks.html%23) is called.

You must change the environment variable `UM_HOST` with the UM deployment name.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| jobs[0].annotations."helm.sh/hook" | string | `"post-install,post-upgrade"` |  |
| jobs[0].annotations."helm.sh/hook-delete-policy" | string | `"hook-succeeded"` |  |
| jobs[0].annotations."helm.sh/hook-weight" | string | `"0"` |  |
| jobs[0].args | list | `["-c","echo Deploying Assets in UM [$UM_HOST] ...; runUMTool.sh CreateConnectionFactory -rname=nsp://$UM_HOST:9000 -factoryname=local_um -factorytype=default -connectionurl=nsp://$UM_HOST:9000 -durabletype=S"]` | Shell script to deploy / create assets in UM using runUMTool.sh |
| jobs[0].command[0] | string | `"/bin/bash"` |  |
| jobs[0].env[0] | object | `{"name":"UM_HOST","value":"pe-realm-um"}` | Environment variable for Shell script |
| jobs[0].env[0].value | string | `"wm-realm-um"` | Set UM Realm deployment (=hostname) |
| jobs[0].image.repository | string | `"sagcr.azurecr.io/universalmessaging-tools"` |  |
| jobs[0].image.tag | float | `10.15` |  |
| jobs[0].imagePullPolicy | string | `"IfNotPresent"` |  |
| jobs[0].name | string | `"deploy-assets-to-um"` |  |
| jobs[0].restartPolicy | string | `"Never"` |  |
