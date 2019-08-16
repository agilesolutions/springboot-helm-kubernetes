#!/bin/bash
curl -LO "https://storage.googleapis.com/kubernetes-helm/helm-v2.8.2-linux-amd64.tar.gz"
tar -xvf helm-v2.8.2-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/
helm init
# update the helm repo
helm repo update