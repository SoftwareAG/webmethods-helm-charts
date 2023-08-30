# MSR using Kubernetes Secrets

This example deploys a MSR that references a Kubernetes secret which is mounted to /etc/secrets on the container at startup. The secrets are referenced through the secret key names in the application properties file provided via config map.

More information about using secrets in Kubernetes for MSR are [here](https://documentation.softwareag.com/webmethods/integration_server/pie10-15/webhelp/pie-webhelp/index.html#page/pie-webhelp%2Fto-configuration_variables_for_docker_11.html%23wwID0ERXBM).

## Prerequisites

Deploy an opaque secret `msr-secrets` to your Kubernetes cluster by executing the following statement:

```bash
# Create secrete for Administrator password ...
kubectl create secret generic msr-secrets --from-literal=ADMIN_PASSWORD=manage
```

```bash
# Create secrete for multiple passwords ...
kubectl create secret generic msr-secrets --from-literal=ADMIN_PASSWORD=manage --from-literal=JDBC_PE_PASSWORD=manage --from-literal=JDBC_PA_PASSWORD=manage
```

Note, you should insert all passwords for a MSR container in one secret. The container can read passwords only from one secret.

In the sample `values.yaml` file you will find an extra volume mount from the secret to `/etc/secrets`.

```yaml
# -- Secret Mount for MSR
secretMounts: 
  - name: msr-secrets
    path: /etc/secrets

# -- Mount volume for secrets
secretVolumes:
  - name: msr-secrets
    secretName: msr-secrets
```

Now, you can reference in application properties the passwords. To set the `ADMIN_PASSWORD` password in a MSR container to `Administrator` user, add the following application property:

```
user.Administrator.password=$secret{ADMIN_PASSWORD}

```
