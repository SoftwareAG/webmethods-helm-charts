⚠️ **WARNING:** Repository moved to IBM public Github: https://github.com/IBM/webmethods-helm-charts. This repository is no longer maintained and will be archived and closed on **31.01.2025**. The IBM repository was set up with the commits until December, 6th 2024 from this repository. 

# Helm Chart Repository for Software AG webMethods Products and Components

This repository contains a collection of Helm charts for various webMethods components. The section *Available Charts* provides more information about the contents. We test and develop all Helm Charts for webMethods release version 10.15.

## Adding the Helm Chart Repository

To add this Helm chart repository to your Helm CLI, run the following command:

```shell
helm repo add webmethods https://open-source.softwareag.com/webmethods-helm-charts/charts
```

To list the content of repository, type `helm search repo webmethods`

```
NAME                                CHART VERSION   APP VERSION     DESCRIPTION
webmethods/mywebmethodsserver           1.0.0           10.15           My webMethods Server (MWS) Helm Chart for Kuber...
webmethods/apigateway                   1.1.0           10.15           API Gateway Helm Chart for Kubernetes
webmethods/common                       1.0.1           1.0.0           A Library Helm Chart for grouping common logic ...
webmethods/developerportal              1.0.0           10.15           webMethods Developer Portal Helm Chart for Kube...
webmethods/microservicesruntime         1.0.3           10.15           Microservices Runtime (MSR) Helm Chart for Kube...
webmethods/terracottabigmemorymax       1.2.0           4.4.0           Terracotta BigMemory Max Helm Chart for Kubernetes
webmethods/universalmessaging           1.0.3           10.15           Universal Messaging (UM) Helm Chart for Kubernetes
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
| [terracottabigmemorymax](https://github.com/SoftwareAG/webmethods-helm-charts/blob/main/terracottabigmemorymax/helm/README.md) | Terracotta BigMemoryMax |

## Chart Versions

Per default, Helm uses the latest version on release installation. If you have successfully installed a webMethods release, you should notice the current used Chart version. Therefore, on further release installation or upgrades (with `helm upgrade --install`) you should use the `--version X.Y.Z` to guarantee that the same is installed everywhere.

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

## Useful links   

📘 Explore the Knowledge Base    
Dive into a wealth of webMethods tutorials and articles in our [Tech Community Knowledge Base](https://tech.forums.softwareag.com/tags/c/knowledge-base/6/webmethods).  

💡 Get Expert Answers    
Stuck or just curious? Ask the webMethods experts directly on our [Forum](https://tech.forums.softwareag.com/tags/c/forum/1/webMethods).  

🚀 Try webMethods    
See webMethods in action with a [Free Trial](https://techcommunity.softwareag.com/en_en/downloads.html).   

✍️ Share Your Feedback    
Your input drives our innovation. If you find a bug, please create an issue in the repository. If you’d like to share your ideas or feedback, please post them [here](https://tech.forums.softwareag.com/c/feedback/2).   

More to discover
* [Helm Charts: Deploying webMethods Components in Kubernetes](https://tech.forums.softwareag.com/t/helm-charts-deploying-webmethods-components-in-kubernetes/285781)  
* [What is Develop Anywhere, Deploy Anywhere?](https://tech.forums.softwareag.com/t/what-is-develop-anywhere-deploy-anywhere/284756)  
------------
These tools are provided as-is and without warranty or support. They do not constitute part of the Software AG product suite. Users are free to use, fork and modify them, subject to the license agreement. While Software AG welcomes contributions, we cannot guarantee to include every contribution in the master project.
