# Deployment of a sample PostgreSQL DB

This describes only how to setup a sample Postgres DB instance in a Kubernetes environment which can be used by webMethods components such as MyWebMethods Server or Microservices Runtime as a database backend. 

For more detailed information on specific parameters please refer to Bitnami's documentation [here](https://github.com/bitnami/charts/tree/main/bitnami/postgresql).


## TL;DR

To install the Bitnami chart with the release name `db` and the password `secret`:

```
helm install db \
    --set auth.postgresPassword=secret
    oci://registry-1.docker.io/bitnamicharts/postgresql
```

You can reference the database via it's service name: 'db-postgresql' later in your JDBC urls.

Example using the Datadirect drivers from webMethods:

```
jdbc:wm:postgresql://db-postgresql:5432;databaseName=postgres
````
