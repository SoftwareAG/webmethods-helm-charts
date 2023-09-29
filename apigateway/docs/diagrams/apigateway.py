from diagrams import Diagram, Cluster
from diagrams.k8s.clusterconfig import HPA
from diagrams.k8s.compute import Deployment, Pod, ReplicaSet,StatefulSet
from diagrams.k8s.network import Ingress, Service
from diagrams.k8s.group import Namespace
from diagrams.k8s.storage import PVC
from diagrams.k8s.storage import PV
from diagrams.k8s.storage import SC
from diagrams.k8s.podconfig import Secret
from diagrams.onprem.monitoring import Prometheus
from diagrams.onprem.client import Client

with Diagram("API Gateway", show=False):    
        client = Client("API Clients")
        with Cluster("API Gateway"):
            with Cluster("API Gateway"):
                net = Ingress("domain.com") 
                svc = Service("*-apigateway")
                pods = [Pod("*-apigateway-*")]
                net >> svc >> pods  << ReplicaSet("rs") << Deployment("*-apigateway-*")
                sec = Secret("*-sag-user-es")
                pods - sec
            with Cluster ("Elastic Search Prometheus"):
                esexporter = Pod("ES Prometheus Exporter")
            with Cluster ("Elastic Search"):
                with Cluster ("Elasticsearch"):
                    es = Service("*-es-http")            
                    pvc = [PVC("*-es-default-*")]
                    espod = [Pod("*-es-default-*")]  
                    es >> espod << StatefulSet("*-es-default") >> pvc 
                with Cluster ("Kibana"):
                    kb = Service("*-kb-http")            
                    kbpod = [Pod("*-kb-default-*")]
                    kbpod << kb
                es << kbpod
            
            espod << esexporter
        with Cluster ("Monitoring"):
            prom = Prometheus("Prometheus")
        client >> net
        esexporter << prom
        pods >> es
        pods << prom
        espod - sec
        pvc >> PV("PV") >> SC("storageclass")

            
