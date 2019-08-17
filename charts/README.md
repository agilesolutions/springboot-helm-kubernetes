# Running and Debugging minimal

* [Goto katacoda](https://www.katacoda.com/courses/kubernetes/helm-package-manager)
* git clone https://github.com/agilesolutions/springboot-helm-kubernetes.git
* cd springboot-helm-kubernetes/charts
* helm inspect minimal
* helm install minimal
* helm ls minimal
* kubectl logs -f xxx -n demo
* kubectl exec xxx -n demo -- ls /tmp 
* kubectl exec xxx -n demo -- cat /tmp/spring.log
* kubectl exec -ti xxx -n  demo -- bin/sh
* kubectl get pods -n demo
* kubectl run demo --image=agilesolutions/demo:latest --replicas=1  
* [read how to debug pods on kubernetes](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application/)