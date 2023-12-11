# webMethods Microservices Runtime Helm Chart

This Helm Chart installs and configures a Microservices Runtime (MSR) container. It is starting with a simple example and provides more complex scenarios in the *Examples for Use-cases* section.

## Prerequisites

### Image Pull Secret

If you want to pull image from [Software AG Containers Registry](https://containers.softwareag.com), create secret with your Software AG Containers Registry credentials ...

```
kubectl create secret docker-registry regcred --docker-server=sagcr.azurecr.io --docker-username=<your-name> --docker-password=<your-pwd> --docker-email=<your-email>
```

### Service Monitor

A Service Monitor CRD can be created optional. Anywhere, the custom kind `ServiceMonitor` must be registered as Kubernetes object. If not, you can apply it with ...

```
kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/bundle.yaml
```

### Create Image for Microservices Runtime

The default is to pull the image from Software AG Containers Registry `sagcr.azurecr.io/webmethods-microservicesruntime`.

If you need to create an own image with additional webMethods product components, you can use the utility [image-creator-using-Azure-DevOps](../../utils/image-creator-using-azure-devops/README.md). On starting the pipeline, you can define a list of product components. You should set in field `List of product components ...` the value `MSC,PIEContainerExternalRDBMS` (as minimum) to create an image with product Microservices Runtime and Database Drivers to connect external databases.

### Licenses

Microservices Runtime requires a license file. These license is supposed to be provided as configmap.

Hence before running `helm install`, create the configmap:

```
kubectl create configmap microservicesruntime-license-key --from-file=licensekey=<your path and filename to Microservices Runtime license file>
```

Optionally you can also provide the license directly when installing your release (see also below).

## Examples for Use-cases

Sub-folder `examples` contains some *values* examples for more use-cases. To use the use-case, adapt and add the provided `values.yaml` to your values.

| Use-case | Description |
|-----|------|
| [external-postgresql-db](../examples/external-postgresql-db/README.md) | Using MSR with external PostgresQL database |
| [msr-defaults](../examples/msr-defaults/README.md) | Recommended default application properties|
| [msr-post-init](../examples/msr-post-init/README.md) | Performs *post-init* actions after startup, e.g. deploy assets to Universal Messaging |
| [msr-push-doc-types](../examples/msr-push-doc-types/README.md) | Pushing IS Document Types after startup |
| [msr-statefulset-csq](../examples/msr-statefulset-csq/README.md) | Deploy MSR with stateful set |
| [msr-using-secrets](../examples/msr-using-secrets/README.md) | Using secrets in application properties and set Administrator password |
| [msr-with-extra-ports](../examples/msr-with-extra-ports/README.md) | Define additional ports in MSR deployment |
| [msr-with-tls](../examples/msr-with-tls/README.md) | Configure Ingress with TLS |
| [process-engine](../examples/process-engine/README.md) | Deploy MSR as Process Engine |
| [service-auditing-monitor](../examples/service-auditing-monitor/README.md) | Deploy MSR as Service Auditing Monitor |

## Install Microservices Runtime Release

Install release with pulling image and setting secret (to pull image) ...

```shell
helm install wm-msr webmethods/microservicesruntime   \
```

... (optionally) provide the license key at installation time (can be ommitted for upgrade later) ...

```shell
--set-file=licensekey=<your path and filename to Microservices Runtime license file> \
```

... set your own image pull secret if you didn't create the default `regcred` ...

```shell
--set "imagePullSecrets[0].name=your-registry-credentials" \
```

... Ingress is enabled per default. Define Ingress service host ...

```shell
  --set "ingress.hosts[0].host=my-msr.mydomain.com"   \
  --set "ingress.hosts[0].paths[0].path=/"            \
  --set "ingress.hosts[0].paths[0].pathType=Prefix"   \
  --set "ingress.hosts[0].paths[0].port=5555"
```

... instead of using default image, use your own ...

```shell
  --set "image.repository=<Your-Docker-registry>/wm-msr-db" \
  --set "image.tag=10.15"
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| containerName | string | `nil` | The name of the main container, by default this will be msr-<release_name> |
| externalLoadBalancer | bool | `false` | Deploy Nginx as external LB |
| extraCommand | string | `""` | Extra command, which is executed before the startContainer entrypoint script of the Microservice Runtime |
| extraConfigMaps | list | `[]` | Extra config maps for addtional configurations such as extra ports, etc. |
| extraContainers | list | `[]` | Extra containers which should run in addtion to the main container as a sidecar - name: do-something   image: busybox   command: ['do', 'something'] |
| extraEnvs | list | `[]` | Exta environment properties to be passed on to the microservice runtime |
| extraInitContainers | list | `[]` | Extra init containers that are executed before starting the main container - name: do-something   image: busybox   command: ['do', 'something'] |
| extraLabels | object | `{}` | Extra Labels |
| extraPorts | list | `[]` | Extra Ports to be defined, note: these ports need to be created  |
| extraVolumeMounts | list | `[]` | Extra volume mounts |
| extraVolumes | list | `[]` | Exta volumes that should be mounted. |
| fullnameOverride | string | `""` | Overwrites full workload name. As default, the workload name is release name + '-' + Chart name. |
| image.pullPolicy | string | `"IfNotPresent"` | Pull with policy |
| image.repository | string | `"sagcr.azurecr.io/webmethods-microservicesruntime"` | Pull this image. Default is MSR from [Software AG Container Registry](https://containers.softwareag.com) |
| image.tag | string | `"10.15"` | The default value pulls latest. In PROD it is recommended to use a specific fix level. |
| imagePullSecrets | list | `[{"name":"regcred"}]` | Image pull secret reference. By default looks for `regcred`. |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.defaultHostname | string | `"msr.mydomain.com"` |  |
| ingress.enabled | bool | `true` |  |
| ingress.hosts[0] | object | `{"host":"","paths":[{"path":"/","pathType":"Prefix","port":5555}]}` | Hostname of Ingress. By default the defaultHostname is used. For more complex rules or addtional hosts, you will need to overwrite this section. |
| ingress.hosts[0].paths | list | `[{"path":"/","pathType":"Prefix","port":5555}]` | Address the backend |
| ingress.hosts[0].paths[0] | object | `{"path":"/","pathType":"Prefix","port":5555}` | Path to address the backend |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` | Path type to address the backend |
| ingress.hosts[0].paths[0].port | int | `5555` | Port of service |
| ingress.tls | list | `[]` | TLS of Ingress |
| lifecycle | object | `{}` | lifecycle hooks to execute on preStop / postStart,... |
| metering.accumulationPeriod | string | `"1800"` | The period in seconds for which data is accumulated before a log record is produced. |
| metering.enabled | bool | `true` | enable metering |
| metering.logLevel | string | `nil` | The level of log messages that are logged on the console. Valid values are: *error - logs only ERROR messages. *warn (default) - logs ERROR and WARN messages. *info - logs ERROR, WARN, and INFO messages. *debug - logs ERROR, WARN, INFO, and DEBUG messages. Use as a Java system property or an environment variable to see the debug messages of the configuration initialization. |
| metering.proxyAddress | string | `nil` | The proxy address in a <host>:<port> format that the metering client uses. Configure this property only if you use a metering proxy. |
| metering.proxyPass | string | `nil` | The proxy password that the metering client uses. Configure this property only if you use a metering proxy with authentication. Depending on the method that you use to provide a password, ensure that you escape password characters that are specific for the selected method. Valid characters: *Letters: A-Z, a-z *Numbers: 0-9 *Special characters: !@#$%^&*()_+-=[]{}\/?,.<>; |
| metering.proxyType | string | `"DIRECT"` | The type of the proxy that the metering client uses. Valid values are: *DIRECT (default). *HTTP *SOCKS Indicates that the metering client does not use a proxy. |
| metering.reportPeriod | string | `"3600"` |  |
| metering.runtimeAlias | string | `nil` | An alias of the webMethods product instance or a group of instances, for which usage data is measured. |
| metering.serverConnectTimeout | string | `"60000"` | The time in milliseconds to establish the initial TCP connection when the metering client calls the server REST endpoint. This is also the time to start the request. |
| metering.serverReadTimeout | string | `"300000"` | The maximum time in milliseconds without data transfer over the TCP connection to the server. This is also the time that it takes for the server to respond. When this time passes, the request fails. |
| metering.serverUrl | string | `"https://metering.softwareag.cloud/api/measurements"` | The URL of the metering aggregator server REST API. |
| metering.trustStoreFile | string | `nil` | The absolute path to the metering client truststore that is used for HTTPS connections. Add this value in any of the following cases: *If you use the Software AG Metering Server on premises (via HTTPS) and the certificates in the truststore do not match the certificates configured in Software AG Runtime (CTP). *If you use a metering proxy that terminates the SSL connection to the Metering Server in Software AG Cloud. |
| metering.trustStorePassword | string | `nil` | The password for the metering client truststore. Configure this property only if you use a truststore. |
| microservicesruntime.diagnosticPort | int | `9999` | Defies diagnostic port |
| microservicesruntime.httpPort | int | `5555` | Defines administration port |
| microservicesruntime.httpPortScheme | string | `"HTTP"` | Defines scheme of administration port |
| microservicesruntime.httpsPort | int | `5556` | Defines external runtime port |
| microservicesruntime.httpsPortScheme | string | `"HTTPS"` | Defines scheme of runtime port  |
| microservicesruntime.installDir | string | `"/opt/softwareag/IntegrationServer"` | Defines installation folder which was using on image creation |
| microservicesruntime.javaCustomOpts | string | `nil` | list of custom java opts e.g. "-Dmy.prop1=value1" "-Dmy.prop2=value2" |
| microservicesruntime.licenseConfigMap | string | `"microservicesruntime-license-key"` | Name of config map which contains the license key. If you ommit this, it defaults to the release name + microservicesruntime-license.  |
| microservicesruntime.memoryHeap.max | string | `"512M"` | Maximum of heap memory |
| microservicesruntime.memoryHeap.min | string | `"512M"` |  |
| microservicesruntime.properties | object | `{}` | List of application properties which are added into config map in YAML format. See [Integration Server Configuration Variables](https://documentation.softwareag.com/webmethods/integration_server/pie10-15/webhelp/pie-webhelp/index.html#page/pie-webhelp%2Fre-configuration_variables_assets.html) |
| microservicesruntime.propertiesFile | object | `{"content":"# application properties file \n"}` | Use "flat" application properties file as generated by configuration variable templates. Note: "properties" takes precedence over the propertiesFile values. Template function,  you can reference other values using template syntax (e.g. using curly braces)  content: |    truststore.DEFAULT_JVM_TRUSTSTORE.ksPassword=$secret{TruststorePasswordSecretName}    property=value    anotherproperty=value    image={{ .Values.image.repository }} # referencing other values |
| microservicesruntime.readinessProbe.scheme | string | `"HTTP"` | Scheme of administration port port, uppercase |
| nameOverride | string | `""` | Overwrites Chart name of release name in workload name. As default, the workload name is release name + '-' + Chart name. The workload name is at the end release name + '-' + value of `nameOverride`. |
| nodeSelector | object | `{}` |  |
| persistence.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.accessModes | list | `[]` |  |
| persistence.annotations | object | `{}` |  |
| persistence.configs | bool | `true` | if persistence.enabled=true, use configuration settings from persistent volume |
| persistence.enabled | bool | `false` | Use persistent volume for IS packages, configuration settings and logs. If `persistence.existingClaim` not set, a claim will be automatically created. |
| persistence.existingClaim | string | `""` | Use this existing and already created PVC. |
| persistence.logs | bool | `true` | if persistence.enabled=true, write logs to persistent volume |
| persistence.packages | bool | `true` | if persistence.enabled=true, externalize packages / use packages from persistent volume |
| persistence.size | string | `"10M"` | Size of Persistent Volume Claim |
| persistence.storageClassName | string | `""` |  |
| podAnnotations | object | `{}` | pod annotations |
| podSecurityContext.fsGroup | int | `1724` |  |
| readinessProbe | object | `{"failureThreshold":3,"initialDelaySeconds":10,"periodSeconds":30,"successThreshold":1,"tcpSocket":{"port":"http"},"timeoutSeconds":1}` | readiness probe for container, by default this will simply check for tcp socket connection. Adjust this in order to avoid routing traffing to non-ready Integration Servers (e.g. use the ping service via http call) |
| replicaCount | int | `1` | Number of replicates in Deployment |
| resources | object | `{}` |  |
| secretMounts | list | `[]` | Secret mounts, A list of secrets and their paths to mount inside the pod |
| secretVolumes | list | `[]` | Secret volumes, A list of secrets |
| securityContext | object | `{}` |  |
| service.port | int | `5555` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| startupProbe | object | `{"failureThreshold":60,"periodSeconds":30,"tcpSocket":{"port":"http"}}` | startup probe for container |
| statefulSet | bool | `false` | StatefulSet or Deployment. You should only change this if you require Client Side queuing (CSQ) or functionality in IS which requires stable hostnames and filesystems. Default is false => Deployment. Keep in mind, you must disable CSQ on each webMethods messaging and JMS connection if you don't use stateful-sets. See examples in Process Engine deployment for disableing QSC. |
| tolerations | list | `[]` |  |
| volumeClaimTemplates | list | `[]` | Volume Claim Templates, only to be used when running as a Statefulset (e.g. using client-side queuing) |
