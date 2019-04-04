#!/bin/bash
set -xe

export OS_TOKEN=fake-token
export OS_URL=http://ironic.openstack.svc.cluster.local:80

cd /usr/src

git clone https://git.openstack.org/openstack/openstack-helm-infra.git
cd ./openstack-helm-infra && git fetch https://git.openstack.org/openstack/openstack-helm-infra refs/changes/97/644897/8 && git checkout FETCH_HEAD

cd /usr/src
git clone https://git.openstack.org/openstack/openstack-helm.git

apt install build-essential -y
cd ./openstack-helm

./tools/deployment/developer/common/010-deploy-k8s.sh

./tools/deployment/developer/common/020-setup-client.sh

./tools/deployment/developer/common/030-ingress.sh

./tools/deployment/developer/nfs/040-nfs-provisioner.sh

./tools/deployment/developer/common/050-mariadb.sh

./tools/deployment/developer/nfs/060-rabbitmq.sh

#./tools/deployment/developer/nfs/070-memcached.sh

#./tools/deployment/developer/nfs/080-keystone.sh

/srv/k8s-helm/virtual-bmc/01.install_pkgs.sh

/srv/k8s-helm/virtual-bmc/02.vsctl.sh

make all && helm upgrade --install ironic /usr/src/openstack-helm/ironic --namespace=openstack --values=/usr/src/openstack-helm/tools/overrides/deployment/baremetal/ironic-standalone.yaml --set pod.replicas.server=1

echo "export OS_TOKEN=fake-token" >> /root/.bashrc
echo "export OS_URL=http://ironic.openstack.svc.cluster.local:80" >> /root/.bashrc

/srv/k8s-helm/scripts/dnsmasq-deploy.sh
