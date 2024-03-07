# Running Microservices Runtime with Fluentd Sidecar

This sample shows how to run Microservices Runtime with a Fluentd sidecar container. This sample will use the "naked" fluentd docker image with no plugins. The fluentd sidecar container will be configured to collect the Microservices Runtime logs from ```/opt/softwareag/IntegrationServer/logs``` and send them to a stdout. For more sophisticated logging, you can use a different fluentd image and configure it to send the logs to a log aggregator such as Elasticsearch.

## Prerequisites

The fluentd sidecar container requires a fluentd configuration file. This sample uses the `fluentd.conf` file. The *fluentd* configuration file is mounted as a volume in the fluentd sidecar container and provided through the sample values file.

## Provided Example

This example provides the [values.yaml](./values.yaml) and use the `extraConfigMaps`, `extraVolumeMounts`, `extraVolumes` and `extraContainers` to setup a fluentd sidecar container.

## Installing the Chart

To install the chart with the release name `msr` in the namespace `msr-fluentd`:

```bash
helm install msr webmethods-helm-charts/microservicesruntime \
  --values webmethods-helm-charts/microservicesruntime/examples/msr-fluentd-sidecar/values.yaml \
  -n msr-fluentd \
  --create-namespace
```

## Uninstalling the Chart

To uninstall/delete the `msr` deployment:

```bash
helm uninstall msr -n msr-fluentd
```
## References

For more examples visit also the samples from API Gateway Helm Chart [API Gateway Example - Fluentd Sidecar](../../../apigateway/examples/fluentd-sidecar/README.md)
