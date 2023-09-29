# Helm Chart Repository for Software AG webMethods Products and Components

This repository contains a collection of Helm charts for various webMethods components. The section *Available Charts* provides more information about the contents. We test and develop all Helm Charts for webMethods release version 10.15.

## Adding the Helm Chart Repository

To add this Helm chart repository to your Helm CLI, run the following command:

```shell
helm repo add webmethods https://open-source.softwareag.com/webmethods-helm-charts/charts
```

To list the content of repository, type `helm search repo webmethods`

```
NAME                            CHART VERSION   APP VERSION     DESCRIPTION
webmethods/mywebmethodsserver   1.0.0           10.15           My webMethods Server (MWS) Helm Chart for Kuber...
webmethods/apigateway           1.0.0           10.15           API Gateway Helm Chart for Kubernetes
webmethods/common               1.0.0           1.0.0           A Library Helm Chart for grouping common logic ...
webmethods/developerportal      1.0.0           10.15           webMethods Developer Portal Helm Chart for Kube...
webmethods/microservicesruntime 1.0.0           10.15           Microservices Runtime (MSR) Helm Chart for Kube...
webmethods/universalmessaging   1.0.0           10.15           Universal Messaging (UM) Helm Chart for Kubernetes
```

## Available Charts READMEs

Each chart has a README for *how to use* and lists some prerequisites.

| Chart Name | Description |
| --- | --- |
| [apigateway](https://github.com/SoftwareAG/webmethods-helm-charts/blob/main/apigateway/helm/README.md) | API Gateway |
| [developerportal](https://github.com/SoftwareAG/webmethods-helm-charts/blob/main/developerportal/helm/README.md) | webMethods Developer Portal |
| [microservicesruntime](https://github.com/SoftwareAG/webmethods-helm-charts/blob/main/microservicesruntime/helm/README.md) | Microservices Runtime (MSR) |
| [mywebmethodsserver](https://github.com/SoftwareAG/webmethods-helm-charts/blob/main/mywebmethodsserver/helm/README.md) | My webMethods Server (MWS) |
| [universalmessaging](https://github.com/SoftwareAG/webmethods-helm-charts/blob/main/universalmessaging/helm/README.md) | Universal Messaging (UM) |

## Utilities

To adopt Microservices Runtime for your deployment and environment or to build images, there is a collection of utilities:

| Utility | Description |
| --- | --- |
| [image-builder-dcc](https://github.com/SoftwareAG/webmethods-helm-charts/blob/main/utils/image-builder-dcc/README.md) | Script to create Image for Database Component Configurator (DCC) |
| [PostgreSQL](https://github.com/SoftwareAG/webmethods-helm-charts/blob/main/utils/postgresql/README.md) | Information to deploy a PostgreSQL database |
| [BPM Demo](https://github.com/SoftwareAG/webmethods-helm-charts/blob/main/utils/bpm-demo/README.md) | BPM scenarios to deploy MSR as Process Engine |
| [Image Builder using Azure DevOps](https://github.com/SoftwareAG/webmethods-helm-charts/blob/main/utils/image-builder-using-azure-devops/README.md) | webMethods Image builder using Azure DevOps pipelines |

## Contributing

If you want to contribute to this repository, please read the [contributing guidelines](./CONTRIBUTING.md) first.

------------
These tools are provided as-is and without warranty or support. They do not constitute part of the Software AG product suite. Users are free to use, fork and modify them, subject to the license agreement. While Software AG welcomes contributions, we cannot guarantee to include every contribution in the master project.
