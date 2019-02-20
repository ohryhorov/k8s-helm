#!/bin/bash -xv

#TEMPLATE_DIR=${REPO_DIR}/templates

date

kubeadm init --pod-network-cidr=10.20.0.0/16

date

mkdir -p /root/.kube
cp -f /etc/kubernetes/admin.conf /root/.kube/config

kubectl get pods --all-namespaces --kubeconfig /root/.kube/config

date

kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml --kubeconfig /root/.kube/config

#curl -L https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml -o S{TEMPLATE_DIR}/calico.yaml
#5. Define CIDR in calico.yaml
#6. kubectl apply -f ./calico.yaml
kubectl get pods --all-namespaces --kubeconfig /root/.kube/config

kubectl taint nodes --all node-role.kubernetes.io/master- --kubeconfig /root/.kube/config

wget https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz && tar zxvf helm-v2.12.3-linux-amd64.tar.gz && mv ./linux-amd64/helm /usr/bin

echo ${HOME}

kubectl create serviceaccount -n kube-system tiller --kubeconfig /root/.kube/config
kubectl create clusterrolebinding tiller-binding --clusterrole=cluster-admin --serviceaccount kube-system:tiller --kubeconfig /root/.kube/config
helm init --service-account tiller
