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
| [BPM Demo](./utils/bpm-demo/README.md) | Discuss BPM scenarios to deploy MSR as Process Engine |

## Contributing

If you want to contribute to this repository, please read the [contributing guidelines](./CONTRIBUTING.md) first.
