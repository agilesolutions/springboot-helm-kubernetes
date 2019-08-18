#!/bin/bash
cd nginx
# This command installs the Nginx Ingress Controller from the stable charts repository, names the Helm release nginx-ingress, and sets the publishService parameter to true.
helm install --name nginx --set controller.publishService.enabled=true --values myvalues.yaml --namespace nginx .
cd ../prometheus
helm install --name prometheus --values myvalues.yaml --namespace prometheus .
cd ../fluentd
helm install --name fluentd --values myvalues.yaml --namespace fluentd .
cd ../jenkins
helm install --name jenkins--values myvalues.yaml --namespace jenkins .
