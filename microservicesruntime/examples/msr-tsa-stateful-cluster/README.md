# Deploy MSR stateful Cluster with Terracotta Big Memory Max Server Array (TSA)

Set the values described in this document in your `values.yaml` to deploy a MSR *stateful* cluster with distributed caches. *stateful* is here in this context only the data with are stored in the distributed cache.

Note, you must configured for other data e.g. CSQ if you want to have a stateful container. See example [msr-statefulset-csq](../msr-statefulset-csq/README.md).

## Prerequisites

Use the [Terracotta Big Memory Helm Chart](../../../terracottabigmemorymax/helm/README.md) to deploy a TSA in your namespace of MSR.

After deployment, TSA can be connected on `terracotta-service:9510` in your namespace.

## Setup `values.yaml`

* Add Terracotta License Key using `extra...` configuration settings and mount the volume ...

```
extraConfigMaps:
  - name: cache-tsa-config
    data: 
      terracotta-license.key: |
        # copy/past here the content of LK ...
        Date of Issue: ...


extraVolumeMounts:
  - name: terracotta-license-key
    mountPath: /opt/softwareag/common/conf/terracotta-license.key
    subPath: terracotta-license.key

extraVolumes:
  - name: terracotta-license-key
    configMap:
      name: cache-tsa-config
```

* Add following WATT settings to configure the TSA URL `terracotta-service:9510` cluster in MSR ...

```
  propertiesFile: 
    content: |
      settings.watt.server.cluster.aware=true
      settings.watt.server.cluster.name="{{ include "common.names.fullname" . }}"
      settings.watt.server.cluster.tsaURLs=terracotta-service:9510
      settings.watt.server.cluster.SessTimeout=60
      settings.watt.server.cluster.action.errorOnStartup=standalone
```

* Unfortunately, the cluster is going to health status `UP` only if there are minimum 2 nodes up and running. Therefore increase the replicates ...

```
# -- Number of replicates in Deployment
replicaCount: 2
```

Note: You can change the threshold of nodes in `./config/healthindicators/healthindicators.cnf` of MSR container.
