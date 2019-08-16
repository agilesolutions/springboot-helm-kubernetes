#!/bin/bash
cd nginx
helm install --name nginx--values myvalues.yaml --namespace nginx . --dry-run
cd ../prometheus
helm install --name prometheus --values myvalues.yaml --namespace prometheus .
cd ../fluentd
helm install --name fluentd --values myvalues.yaml --namespace fluentd .
cd ../jenkins
helm install --name jenkins--values myvalues.yaml --namespace jenkins .
