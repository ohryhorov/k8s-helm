#!/bin/bash -xv

export OS_TOKEN=fake-token
export OS_URL=http://ironic.openstack.svc.cluster.local:80

#/srv/k8s-helm/virtual-bmc/01.install_pkgs.sh

#/srv/k8s-helm/virtual-bmc/02.vsctl.sh

/srv/k8s-helm/scripts/dnsmasq-deploy.sh

/srv/k8s-helm/virtual-bmc/03.boot_ironic_vm.sh
