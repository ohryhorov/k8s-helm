#!/bin/bash -xv

#TEMPLATE_DIR=${REPO_DIR}/templates

date

kubeadm init --pod-network-cidr=10.20.0.0/16

date

mkdir -p /root/.kube
cp -f /etc/kubernetes/admin.conf /root/.kube/config

kubectl get pods --all-namespaces --kubeconfig /root/.kube/config
