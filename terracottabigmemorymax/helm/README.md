# Terracotta BigMemory Max Helm Chart

## Disclaimer and Warnings

**The user is responsible for customizing these files on-site.**
This Helm chart is provided as a minimal requirement to install Terracotta BigMemory Max on k8s.

---

*Considering the complexity of k8s settings regarding pod and volume lifecycle in the context of a multi-stripe active/passive cluster it is strongly advised that the user consult with a k8s expert.*

*Pay attention that the nature of k8s automatically handling pod restart and volume assignment can go against the expected normal behavior of Terracotta Servers on a traditional infrastructure. This can lead to unexpected behaviors and / or malfunctioning clusters.*

*Terracotta Servers embed a mechanism to automatically restart in case of failure or configuration change, and eventually can invalidate the data on disk (to be wiped). This mechanism is not compatible with the default k8s lifecycle management which can for example respawn a pod on a pre-existing volume where the data has been marked invalidated.*

---

## QuickStart

From the helm directory

```bash
helm install <release-name> --set-file license=<license-file> --set tag=4.3.10-SNAPSHOT .
```

**IMPORTANT note:** license and tag are mandatory parameter that need to be set during helm chart installation.

There are other parameters defined in values.yaml which can be overridden as well during installation which can be used
for changing how terracotta cluster should be deployed in kubernetes environment. By default it deploys BigMemory
cluster with two stripe each having two nodes and a tmc inside kubernetes.

### Security

### Image Pull Secret

Provide an image pull secret for the registry where the desired images  are to be pulled from.

```
kubectl create secret docker-registry regcred --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pwd> --docker-email=<your-email>
```

### STEP #1: Create a secret

Suppose you are creating a 2*1 bigmemory cluster and 1 tmc then Create a secret which contains following files

- terracotta-0-keystore.jks :- keystore file for server1.
- terracotta-1-keystore.jks :- keystore file for server2.
- tmc-0-keystore.jks :- keystore file for tmc.
- truststore.jks :- truststore file containing public certs for all the above keystores.
- keychain - keychain file containing password for everything. For ex-

````
Terracotta Command Line Tools - Keychain Client
tc://user@terracotta-1.terracotta-service.default.svc.cluster.local:9540 : chunuAa1$
file:/opt/softwareag/.tc/mgmt/truststore.jks : chunuAa1$
file:/opt/softwareag/run/truststore.jks : chunuAa1$
tc://user@terracotta-1.terracotta-service.default.svc.cluster.local:9510 : chunuAa1$
tc://user@terracotta-1.terracotta-service.default.svc.cluster.local:9530 : chunuAa1$
file:/opt/softwareag/.tc/mgmt/tmc-0-keystore.jks : chunuAa1$
https://terracotta-1.terracotta-service.default.svc.cluster.local:9540/tc-management-api : chunuAa1$
https://terracotta-0.terracotta-service.default.svc.cluster.local:9540/tc-management-api : chunuAa1$
tc://user@terracotta-0.terracotta-service.default.svc.cluster.local:9510 : chunuAa1$
jks:terracotta-0-alias@/opt/softwareag/run/terracotta-0-keystore.jks : chunuAa1$
tc://user@terracotta-0.terracotta-service.default.svc.cluster.local:9540 : chunuAa1$
tc://user@terracotta-0.terracotta-service.default.svc.cluster.local:9530 : chunuAa1$
jks:terracotta-1-alias@/opt/softwareag/run/terracotta-1-keystore.jks : chunuAa1$
````

- tmc-https.ini :- For enabling ssl connections in jetty. For ex-

````
jetty.sslContext.keyManagerPassword=OBF:1fwe1jg61vgz1nsc1zen1npu1vfv1jd41fsw
jetty.sslContext.keyStorePassword=OBF:1fwe1jg61vgz1nsc1zen1npu1vfv1jd41fsw
jetty.sslContext.trustStorePassword=OBF:1fwe1jg61vgz1nsc1zen1npu1vfv1jd41fsw
````

- terracotta.ini :- contains user with name 'user' as we are using it in generated tc-config.xml.

````
./usermanagement.sh -c terracotta.ini user terracotta admin
````

Example to create secret in k8s cluster manually -

````
kubectl create secret generic certificatesecret \
--from-file=/home/mdh@eur.ad.sag/4.xconfig/k8sCert/keychain \
--from-file=/home/mdh@eur.ad.sag/4.xconfig/k8sCert/terracotta-0-keystore.jks \
--from-file=/home/mdh@eur.ad.sag/4.xconfig/k8sCert/truststore.jks \
--from-file=/home/mdh@eur.ad.sag/4.xconfig/k8sCert/terracotta.ini \
--from-file=/home/mdh@eur.ad.sag/4.xconfig/k8sCert/tmc-0-keystore.jks \
--from-file=/home/mdh@eur.ad.sag/4.xconfig/k8sCert/tmc-https.ini \
--from-file=/home/mdh@eur.ad.sag/4.xconfig/k8sCert/terracotta-1-keystore.jks
````

### Step #2: Install the helm chart and use the above created secret.

````
helm install "my-release" --set stripeCount=2 --set nodeCountPerStripe=1 --set-file license=/home/mdh@eur.ad.sag/4.xlicense/license.key --set tag=4.3.10-SNAPSHOT --set security=true --set secretName=certificatesecret  .
````

### Step #3: Verify from the browser to see if connections can be created securely to tmc.

- First enable port-forwarding for tmc-service using -

````
kubectl port-forward service/tmc-service 8080:9443
````

- Go to browser and go to url https://localhost:8080 and then set up authentication.
- It will ask for tmc restart so do it using

```
kubectl delete pod tmc-0.
```

- Now again start port-forwarding and go to browser and connect to following url -

```
https://terracotta-0.terracotta-service.default.svc.cluster.local
```

- When asking for user name enter "user" . It should be able to connect and show cluster information on browser.


### Prometheus support
Terracotta BigMemory provides a list of key metrics in Prometheus compatible format over HTTP on TMC endpoint:
```
http(s)://<host>:<port>/tmc/api/prometheus
```
Sample config to add BigMemory as a target in the prometheus.yml configuration file

For non secure cluster - 
```
- job_name: 'big_memory'
    metrics_path: /tmc/api/prometheus
    static_configs:
        - targets: ['localhost:9889']
```

For secure cluster - 
```
- job_name: 'big_memory'
    scheme: https
    metrics_path: /tmc/api/prometheus
    static_configs:
    - targets: ['localhost:9443']
    basic_auth:
      username: <username>
      password: <password>
    tls_config:
      ca_file: <path-to-tmc-certificate>
```

### Step #4: For removing deployment from kubernetes cluster.

```bash
helm delete <release-name>
```

## Version History

| Version | Changes and Description |
|---------|-------------------------|
| `1.0.0' | Initial release         |
| `1.1.0' | Available from GitHub   |

{{ template "chart.valuesSection" . }}
