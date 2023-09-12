# Helm Chart Repository for Software AG webMethods Components

This repository contains a collection of Helm charts for various webMethods components. The section *Available Charts* provides more information about the contents. We test and develop all Helm Charts for webMethods release version 10.15.

## Adding the Helm Chart Repository

To add this Helm chart repository to your Helm CLI, run the following command:

```shell
helm repo add webmethods https://open-source.softwareag.com/webmethods-helm-charts/charts
```

## Available Charts

| Chart Name | Description |
| --- | --- |
| [microservicesruntime](./microservicesruntime/helm/README.md) | Helm Chart for Microservices Runtime |
| [universalmessaging](./universalmessaging/helm/README.md) | Helm Chart for Universal Messaging |

Under construction are Helm Charts for API Gateway, My webMethods Server and Developer Portal.

## Utilities

To adopt Microservices Runtime for you deployment and environment, there is a collection of utilities:

| Utility | Description |
| --- | --- |
| [dcc](./utils/dcc/README.md) | Script to create Image for Database Component Configurator (DCC) |
| [PostgreSQL](./utils/postgresql/README.md) | Information to deploy a PostgreSQL database |
| [BPM Demo](./utils/bpm-demo/README.md) | BPM scenarios to deploy MSR as Process Engine |
| [Image Creator using Azure DevOps](./utils/image-creator-using-azure-devops/README.md) | webMethods Image creator using Azure DevOps pipeline |


## Contributing

If you want to contribute to this repository, please read the [contributing guidelines](./CONTRIBUTING.md) first.


------------
These tools are provided as-is and without warranty or support. They do not constitute part of the Software AG product suite. Users are free to use, fork and modify them, subject to the license agreement. While Software AG welcomes contributions, we cannot guarantee to include every contribution in the master project.
