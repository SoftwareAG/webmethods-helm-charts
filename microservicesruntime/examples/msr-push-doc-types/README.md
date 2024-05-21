# Pushing Document Types to Provider

With the first deployment of IS packages in MSR (as Helm release), the Document Types should be pushed (synchronized) with the provider. The following sample is implemented as Kubernetes job which is started with Helm hook at `post-install` or `post-upgrade`. To create a Kubernetes job, the template `job.yaml` is used and controlled by values.

## Prerequisites

* The started Kubernetes Job needs access to Internet to download image `ubuntu:latest`, software packages `curl` and `jq`. If Kubernetes has no connection to Internet, create an own image in your container registry with the tools. The [values.yaml](./values.yaml) (for job creating) should be adapted to use your created image.
* `curl` is used to call IS build-in services `pub.utils.messaging:syncDocTypesToUM` and `syncToProvider`. The call requires IS Administrator credentials. To inject the Administrator password into job, you should implement  [examples/msr-using-secrets](../examples/msr-using-secrets/README.md).
* The job requires the hostname of deployed MSR. It is expected that the full name of Helm release Chart can be used. In order to do, the `job.yaml` Helm template contains a line to set the Helm release full name as environment variable `DEPLOYMENT`. The job shell script uses the endpoint `${DEPLOYMENT}:5555` to call IS build-in services.

## Job Template and `DEPLOYMENT` Environment Variable

The [Job template](../../helm/templates/job.yaml) is used to create a Kubernetes (Cron) Job object. A feature of this template is to set the environment variable `DEPLOYMENT` with the full deployment name. The deployment name is equal to the Kubernetes service name.

## Values

If you have solved and committed the above prerequisites, you can include the `example/msr-push-doc-types/values.yalm` in the Helm release install or upgrade command with `-f` option.

The yaml file contains the job parameter with name ...

```yaml
jobs:
- name: push-doc-types
```

... Helm hook annotation ...

```yaml
jobs:
  annotations:
    "helm.sh/hook": post-install,post-upgrade
    "helm.sh/hook-weight": "0"
    "helm.sh/hook-delete-policy": hook-succeeded
```

... Download base image from Internet ...

```yaml
  image:
    repository: ubuntu
    tag: latest
  imagePullPolicy: IfNotPresent
```

... and start the Shell script as job ...

```yaml
        echo Pushing Document Types to Provider for [${DEPLOYMENT}] ...;
        apt-get update;
        apt-get install jq   -y;
        apt-get install curl -y;
        status=$(curl -s -o /dev/null -w "%{http_code}" ${DEPLOYMENT}:5555 -u "Administrator:${ADMIN_PASSWORD}");
        while [[ "${status}" != "200" ]];
        do 
          echo Waiting for IS [${DEPLOYMENT}] status [${status}] ...;
          sleep 10;
          status=$(curl -s -o /dev/null -w "%{http_code}" ${DEPLOYMENT}:5555 -u "Administrator:${ADMIN_PASSWORD}");
        done;
        pusdDTs=$(curl -s -u "Administrator:${ADMIN_PASSWORD}" -H "Content-Type: application/json" "${DEPLOYMENT}:5555/invoke/pub.utils.messaging:syncDocTypesToUM" | jq -r '.updatedDocumentTypes[].name');
        echo "List of Document Types retrieved ...";
        echo [${pusdDTs}];
        for dt in ${pusdDTs};
        do
          echo Pushing [${dt}] ...;
          curl -s -u "Administrator:${ADMIN_PASSWORD}" -H "Content-Type: application/json" "${DEPLOYMENT}:5555/invoke/pub.publish:syncToProvider?documentTypes[0]=${dt}" | jq '.';
        done;
```

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| jobs[0].annotations."helm.sh/hook" | string | `"post-install,post-upgrade"` |  |
| jobs[0].annotations."helm.sh/hook-delete-policy" | string | `"hook-succeeded"` |  |
| jobs[0].annotations."helm.sh/hook-weight" | string | `"0"` |  |
| jobs[0].args[0] | string | `"-c"` |  |
| jobs[0].args[1] | string | `"echo Pushing Document Types to Provider for [${DEPLOYMENT}] ...; apt-get update; apt-get install jq   -y; apt-get install curl -y; status=$(curl -s -o /dev/null -w \"%{http_code}\" ${DEPLOYMENT}:5555 -u \"Administrator:${ADMIN_PASSWORD}\"); while [[ \"${status}\" != \"200\" ]]; do \n  echo Waiting for IS [${DEPLOYMENT}] status [${status}] ...;\n  sleep 10;\n  status=$(curl -s -o /dev/null -w \"%{http_code}\" ${DEPLOYMENT}:5555 -u \"Administrator:${ADMIN_PASSWORD}\");\ndone; pusdDTs=$(curl -s -u \"Administrator:${ADMIN_PASSWORD}\" -H \"Content-Type: application/json\" \"${DEPLOYMENT}:5555/invoke/pub.utils.messaging:syncDocTypesToUM\" | jq -r '.updatedDocumentTypes[].name'); echo \"List of Document Types retrieved ...\"; echo [${pusdDTs}]; for dt in ${pusdDTs}; do\n  echo Pushing [${dt}] ...;\n  curl -s -u \"Administrator:${ADMIN_PASSWORD}\" -H \"Content-Type: application/json\" \"${DEPLOYMENT}:5555/invoke/pub.publish:syncToProvider?documentTypes[0]=${dt}\" | jq '.';\ndone;"` |  |
| jobs[0].command[0] | string | `"/bin/bash"` |  |
| jobs[0].envFrom[0].secretRef.name | string | `"msr-secrets"` |  |
| jobs[0].image.repository | string | `"ubuntu"` |  |
| jobs[0].image.tag | string | `"latest"` |  |
| jobs[0].imagePullPolicy | string | `"IfNotPresent"` |  |
| jobs[0].name | string | `"push-doc-types"` |  |
| jobs[0].restartPolicy | string | `"Never"` |  |

## Usage Notes

At the first time, you should include this feature in your Helm release install or upgrade command after MSR container is stable running. If MSR is not coming up (e.g. database connection issue) the Helm command is waiting until hooks are closed and you have a lot of work to cleanup Kubernetes job and Pods.
