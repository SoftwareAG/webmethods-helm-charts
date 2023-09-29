from diagrams import Cluster, Diagram, Edge
from diagrams.gcp.analytics import BigQuery, Dataflow, PubSub
from diagrams.gcp.compute import AppEngine, Functions
from diagrams.gcp.database import BigTable
from diagrams.gcp.iot import IotCore
from diagrams.gcp.storage import GCS
from diagrams.k8s.compute import *
from diagrams.k8s.network import *
from diagrams.onprem.network import *
from diagrams.elastic.elasticsearch import *

with Diagram("Paired Setup", direction='LR', show=False):
    nginx = Nginx("Ingress Controller")

    with Cluster("DMZ"):
        with Cluster("API Gateway"):
            pod = Pod("API GW")
            svc = Service("API GW")
            svcin = Service("API GW")
            ing = Ingress("mydomain.com")
            svc << Edge(label="Reverse Invoke") << nginx
            pod << svc
            svcin >> pod
            ing >> svcin
        with Cluster("Elastic Search"):            
            kb = Kibana("KB")
            es = Elasticsearch("ES")
            kb - Edge(pencolor="transparent") - es 
        pod >> es

    with Cluster("Greenzone"):
        with Cluster("API Gateway"):
            gpod = Pod("API GW")
            gsvc = Service("API GW")                        
            ging = Ingress("myinternal domain")
            gpod << gsvc << ging
        with Cluster("Elastic Search"):            
            gkb = Kibana("KB")
            ges = Elasticsearch("ES")
            gkb - Edge(pencolor="transparent") - ges 
        gpod >> ges

    nginx << Edge(label="Reverse Invoke") << gpod
    

