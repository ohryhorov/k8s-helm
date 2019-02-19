#!/bin/bash

#TEMPLATE_DIR=${REPO_DIR}/templates

kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml

kubeadm init --pod-network-cidr=10.20.0.0/16

#curl -L https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml -o S{TEMPLATE_DIR}/calico.yaml
#5. Define CIDR in calico.yaml
#6. kubectl apply -f ./calico.yaml
kubectl get pods --all-namespaces

kubectl taint nodes --all node-role.kubernetes.io/master-

wget https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz && tar zxvf helm-v2.12.3-linux-amd64.tar.gz && mv ./linux-amd64/helm /usr/bin

kubectl create serviceaccount -n kube-system tiller
kubectl create clusterrolebinding tiller-binding --clusterrole=cluster-admin --serviceaccount kube-system:tiller
helm init --service-account tiller
