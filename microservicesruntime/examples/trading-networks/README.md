# Trading Networks (TN) Deployment

This example guides you to deploy Trading Networks (TN) in a container environment.

## Architecture

We need following containers to run ...

* Integration Server with Trading Network Server and EDI adapters
* My webMethods Server for Monitoring for Trading Network Portal
* Universal Messaging
* Database(s)
* if you want to have more than 1 MSR/IS node, TN needs a distributed cache. In this case, a Terracotta Server Array (TSA) is required to setup a cluster.

## Prerequisites

* License Key for MSR and Trading Networks
* Image Build Environment, e.g. [image-builder-using-azure-devops](../../../utils/image-builder-using-azure-devops/README.md)

## Create Base Image for TN Server

With using [image-builder-using-azure-devops](../../../utils/image-builder-using-azure-devops/README.md) and pipeline `azure-pipelines-own-entrypoint`, you can create the TN Server image with following parameters ...

```
PRODUCTS: "integrationServer,Monitor,PIEContainerExternalRDBMS,TNServer,1syncDoc,1sync,EDIINT,EDICore,EDIEANCOM,EDIODETTE,EDITRADACOMS,EDIUCS,EDIUNEDIFACTMisc,EDIUNEDIFACT1990,EDIUNEDIFACT1991,EDIUNEDIFACT1992,EDIUNEDIFACT1993,EDIUNEDIFACT1994,EDIUNEDIFACT1995,EDIUNEDIFACT1996,EDIUNEDIFACT1997,EDIUNEDIFACT1998,EDIUNEDIFACT1999,EDIUNEDIFACT2000,EDIUNEDIFACT2001,EDIUNEDIFACT2002,EDIUNEDIFACT2003,EDIUNEDIFACT2004,EDIUNEDIFACT2005,EDIUNEDIFACT2006,EDIUNEDIFACT2007,EDIUNEDIFACT2008,EDIUNEDIFACT2009,EDIUNEDIFACT2010,EDIUNEDIFACT2011,EbXMLCore"

ENTRYPOINT: "/opt/softwareag/IntegrationServer/bin/startContainer.sh"

BASE_IMAGE: "centos:8"
```

The entrypoint `startContainer.sh` requires additional environment variable `INSTANCE_NAME`. Therefore, you must increase the already created image using Docker `build` and Docker file ...

```
FROM your-created-image-with-azure-pipelines-own-entrypoint

ENV INSTANCE_NAME=default
```

Create a new image with `docker build -t wm-tn .`

## Create Base Image for My webMethods Server as TN Portal

With using [image-builder-using-azure-devops](../../../utils/image-builder-using-azure-devops/README.md) and pipeline `azure-pipelines`, 

```
PRODUCTS: MwsProgramFiles,monitorUI,optimizeSharedUI,optimizeUI,centralConfiguratorUI,TNPortal

BASE_IMAGE : "centos:8"
```

## Create TN Database Schema

You must use the Database Component Configurator to create the TN schemas (parameter `-pr TN`) in you database. If you have an already created DCC image with ([image-builder-using-azure-devops](../../../utils/image-builder-using-azure-devops/README.md)), you can call the DCC with following `kubectl` command. The following command use an existing PostgresQL database ...

```
kubectl run wm-dcc-client --rm --tty -i --restart=Never --namespace TN --image wm-dcc:10.15.01 --command -- /opt/softwareag/common/db/bin/dbConfigurator.sh -a CREATE -l "jdbc:wm:postgresql://tn-db-postgresql:5432;databaseName=wmdb" --dbms postgresql -u wm -p "password" -pr TN
```

## Add TN JDBC Pool in TN Server

Add following JDBC database pool configuration in `application.properties` of MSR/IS to access the TN database ...

```
jdbc.tn.dbURL=jdbc:wm:postgresql://tn-postgresql:5432;databaseName=wmdb
jdbc.tn.driverAlias=DataDirect Connect JDBC PostgreSQL Driver
jdbc.tn.maxConns=10
jdbc.tn.password=...
jdbc.tn.userid=...
jdbcfunc.TN.connPoolAlias=tn
```

## TN Configuration for Containers

To configure TN at IS/MSR container, you can setup appropriated `application.properties` in `values.yaml` (how described [here](https://documentation.softwareag.com/webmethods/trading_networks/otn10-15/webhelp/otn-webhelp/#page/otn-webhelp%2Fto-tn_4.html%23)). The [available TN properties](https://documentation.softwareag.com/webmethods/trading_networks/otn10-15/webhelp/otn-webhelp/#page/otn-webhelp%2Fto-app_tn_config_props.html%23) must have the `tnProperty` prefix that IS/MSR (with MSR License) call pull these at startup time.

## TN Server @ Cluster

Optional, if you want to replicate the TN server then you must setup Terracotta for a distributed cache. You can use the described [msr-tsa-stateful-cluster](../msr-tsa-stateful-cluster/README.md) example.

## Install TN Server Release

At least, you have the `application.properties` and a `values.yaml` (e.g. `tn-values.yaml`) file configured, you can install in a new namespace `TN` the MSR with Helm ...

```
helm upgrade --install msr-tn webmethods/microservicesruntime -n TN --create-namespace -f tn-values.yaml
```

## Install TN Portal Release

To install the TN Portal, use the [My webMethods Server Helm Chart](../../../mywebmethodsserver/helm/README.md) with the image which you have already created.
