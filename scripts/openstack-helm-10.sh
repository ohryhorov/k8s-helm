#!/bin/bash
set -xe

cd /usr/src

git clone https://git.openstack.org/openstack/openstack-helm-infra.git
git clone https://git.openstack.org/openstack/openstack-helm.git

apt install build-essential -y
cd ./openstack-helm && ./tools/deployment/developer/common/010-deploy-k8s.sh

./tools/deployment/developer/common/020-setup-client.sh

./tools/deployment/developer/common/030-ingress.sh

./tools/deployment/developer/nfs/040-nfs-provisioner.sh

./tools/deployment/developer/common/050-mariadb.sh

./tools/deployment/developer/nfs/060-rabbitmq.sh

./tools/deployment/developer/nfs/070-memcached.sh

./tools/deployment/developer/nfs/080-keystone.sh

