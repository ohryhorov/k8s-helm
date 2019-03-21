#!/bin/bash
set -xe

cd /usr/src

git clone https://git.openstack.org/openstack/openstack-helm-infra.git
cd ./openstack-helm-infra && git fetch https://git.openstack.org/openstack/openstack-helm-infra refs/changes/97/644897/2 && git checkout FETCH_HEAD

git clone https://git.openstack.org/openstack/openstack-helm.git

apt install build-essential -y
cd ./openstack-helm && git fetch https://git.openstack.org/openstack/openstack-helm refs/changes/15/636715/6 && git checkout FETCH_HEAD

./tools/deployment/developer/common/010-deploy-k8s.sh

./tools/deployment/developer/common/020-setup-client.sh

./tools/deployment/developer/common/030-ingress.sh

./tools/deployment/developer/nfs/040-nfs-provisioner.sh

./tools/deployment/developer/common/050-mariadb.sh

./tools/deployment/developer/nfs/060-rabbitmq.sh

#./tools/deployment/developer/nfs/070-memcached.sh

#./tools/deployment/developer/nfs/080-keystone.sh

make all && helm upgrade --install ironic /usr/src/openstack-helm/ironic --namespace=openstack --values=/srv/k8s-helm/values/sa-ironic.yaml --set pod.replicas.server=1

echo "export OS_TOKEN=fake-token" >> /root/.bashrc
echo "export OS_URL=http://ironic.openstack.svc.cluster.local:80" >> /root/.bashrc
