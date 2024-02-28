# Deployment in OpenShift

This basic example shows how to deploy a Microservices Runtime (MSR) in OpenShift. 

## Prerequisites

Make sure that you have installed the [OpenShift CLI](https://docs.openshift.com/container-platform/4.3/cli_reference/openshift_cli/getting-started-cli.html) (`oc`) and that you are logged in to your OpenShift cluster. 

For local testing, you can use [Minishift](https://docs.okd.io/latest/minishift/getting-started/installing.html) or [CodeReady Containers](https://developers.redhat.com/products/codeready-containers/overview).


## Route

The Microservices Runtime is exposed via a route. The route is created by the Helm chart by enabling the ```route.enabled``` flag in the values. Check the route with the following command if msr-openshift is the release name:

```bash
oc get route msr-openshift
```

## Deploying the Microservices Runtime

To deploy the Microservices Runtime, run the following command (in the directory where this README.md is located):

```bash
helm install msr-openshift webmethods-helm-charts/microservicesruntime -f values.yaml
```
