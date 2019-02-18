#!/bin/bash
set -xe

git clone https://git.openstack.org/openstack/openstack-helm-infra.git
git clone https://git.openstack.org/openstack/openstack-helm.git

apt install build-essential -y
cd ./openstack-helm && ./tools/deployment/developer/common/010-deploy-k8s.sh

./tools/deployment/developer/common/020-setup-client.sh

./tools/deployment/developer/common/030-ingress.sh
