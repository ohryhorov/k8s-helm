1. Execute all prered scripts

2. kubeadm init --pod-network-cidr=10.20.0.0/16

3. kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml

4. wget https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml

5. Define CIDR in calico.yaml

6. kubectl apply -f ./calico.yaml
   To check:
     kubectl get pods --all-namespaces

7. To bring pods on master node
     kubectl taint nodes --all node-role.kubernetes.io/master-

8. wget https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz && tar zxvf helm-v2.12.3-linux-amd64.tar.gz && mv ./linux-amd64/helm /usr/bin

     kubectl create serviceaccount -n kube-system tiller
     kubectl create clusterrolebinding tiller-binding --clusterrole=cluster-admin --serviceaccount kube-system:tiller
     helm init --service-account tiller

9. openstack-helm-10.sh
