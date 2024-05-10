# MSR with Ingress and TLS

This example shows how to configure the microservices runtime deployment to use an SSL / TLS endpoint. 

## Prerequisites

For this example you will need to deploy a TLS secret named `tls-secret` to be deployed.

```
kubectl create secret generic tls-secret --cert=path/to/certificate.crt --key=path/to/private.key --namespace=my-namespace
```

## Values

You can add following values.yaml](./values.yaml).
