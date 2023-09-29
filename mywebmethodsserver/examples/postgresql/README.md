# Deployment with external PostgreSQL Database

This sample shows how to deploy MyWebMethods Server with a PostgreSQL database backend.

## Prerequisites

Additional to [MyWebMethods Server Prerequisites](../../helm/README.md), you need an already created container image with ...
* MyWebmethods Server

See *Deploy a PostgreSQL* to create database if don't have such.

## Deploy a PostgreSQL

Create a PostgreSQL database ...

```shell
helm repo add bitnami https://charts.bitnami.com/bitnami

helm install wm-mws-db bitnami/postgresql --namespace mws \
  --set global.postgresql.auth.postgresPassword=manage    \
  --set global.postgresql.auth.username=wm                \
  --set global.postgresql.auth.password=manage            \
  --set global.postgresql.auth.database=wmdb              \
  --set primary.persistence.size=100M
```

## Create webMethods Database Components

Before starting MyWebMethods Server, the `wmdb` database must be filled with assets using Database Component Configurator (DCC). See [Database Component Creator (DCC)](../../utils/dcc/README.md) to create an image for DCC. After DCC image `wm-dcc:10.15` is created, use following Kubernetes `run` command to create the *product* components `IS` in `wm-mws-db`:

```shell
kubectl run wm-dcc-client --rm --tty -i --restart='Never' --image wm-dcc:10.15 --namespace mws --command -- /opt/softwareag/common/db/bin/dbConfigurator.sh -a CREATE -l "jdbc:wm:postgresql://wm-mws-db:5432;databaseName=wmdb" --dbms postgresql -u wm -p "manage" -pr MWS
```

## Install MyWebMethods Server Release

Install release 

```shell
helm install wm-mws webmethods/mywebmethodsserver
```