# UM Deployment with Post-Initialization

This example starts a post-initialization job to configure UM after release installation. The job is starting on Helm installation hooks `post-install` and `post-upgrade` and uses the UM administration tool [runUMTool.sh](https://documentation.softwareag.com/universal_messaging/num10-15/webhelp/num-webhelp/index.html#page/num-webhelp%2Fto-title_clu_administration_tools.html%23).

## Prerequisites

See general Prerequisites.

## Job Template and `DEPLOYMENT` Environment Variable

The [Job template](../../helm/templates/job.yaml) is used to create a Kubernetes (Cron) Job object. A feature of this template is to set the environment variable `DEPLOYMENT` with the full deployment name. The deployment name is equal to the Kubernetes service name.

## Values

Download the [values.yaml](./values.yaml) file. Add the content to you existing or create a new file. Afterwards, you can install the release with ...

```
helm install um webmethods/universalmessaging -f values.yaml
```

[values.yaml](./values.yaml) has following content ...

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| jobs[0].annotations."helm.sh/hook" | string | `"post-install,post-upgrade"` |  |
| jobs[0].annotations."helm.sh/hook-delete-policy" | string | `"hook-succeeded"` |  |
| jobs[0].annotations."helm.sh/hook-weight" | string | `"0"` |  |
| jobs[0].args | list | `["-c","echo Deploying Assets in UM [$DEPLOYMENT] ...; runUMTool.sh CreateConnectionFactory -rname=nsp://$DEPLOYMENT:9000 -factoryname=local_um -factorytype=default -connectionurl=nsp://$DEPLOYMENT:9000 -durabletype=S"]` | Shell script to deploy / create assets in UM using [runUMTool.sh](https://documentation.softwareag.com/universal_messaging/num10-15/webhelp/num-webhelp/index.html#page/num-webhelp%2Fto-title_clu_administration_tools.html%23) The following sample creates a Connection Factory using environment variable `$DEPLOYMENT` to reach the UM host.  |
| jobs[0].command[0] | string | `"/bin/bash"` |  |
| jobs[0].image.repository | string | `"sagcr.azurecr.io/universalmessaging-tools"` |  |
| jobs[0].image.tag | float | `10.15` |  |
| jobs[0].imagePullPolicy | string | `"IfNotPresent"` |  |
| jobs[0].name | string | `"post-init"` |  |
| jobs[0].restartPolicy | string | `"Never"` |  |
