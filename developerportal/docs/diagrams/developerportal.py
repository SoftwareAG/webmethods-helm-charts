from diagrams import Diagram, Cluster
from diagrams.k8s.clusterconfig import HPA
from diagrams.k8s.compute import Deployment, Pod, ReplicaSet,StatefulSet
from diagrams.k8s.network import Ingress, Service
from diagrams.k8s.group import Namespace
from diagrams.k8s.storage import PVC
from diagrams.k8s.storage import PV
from diagrams.k8s.storage import SC
from diagrams.k8s.podconfig import Secret

with Diagram("Developer Portal", show=False):    
        with Cluster("Developer Portal"):
            net = Ingress("domain.com") >> Service("*-developerportal")
            pods = [Pod("*-developerportal-*")]
            net >> pods  << ReplicaSet("rs") << StatefulSet("*-developerportal-*")
            sec = Secret("*-sag-user-es")
            pods - sec
        with Cluster ("Elastic Search"):
            es = Service("*-es-http")            
            pvc = [PVC("*-es-default-*")]
            es >> [Pod("*-es-default-*")]  << StatefulSet("*-es-default") << pvc 
        pvc << PV("PV") << SC("storageclass")

            
