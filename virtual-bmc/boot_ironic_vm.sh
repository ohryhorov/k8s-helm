#!/bin/bash

virsh vol-create-as default bmt01-n0.qcow2 --capacity 10G --format qcow2

virsh pool-info default

virsh define /srv/k8s-helm/virtual-bmc/bmt01-n0.xml

vbmc add bmt01-n0 --port 6200
vbmc start bmt01-n0
vbmc show bmt01-n0

NODE_UUID=`openstack baremetal node create --driver ipmi \
    --driver-info ipmi_address=192.168.90.9 \
    --driver-info ipmi_port=6200 \
    --driver-info ipmi_username=admin \
    --driver-info ipmi_password=password \
    --driver-info deploy_kernel=https://tarballs.openstack.org/ironic-python-agent/tinyipa/files/tinyipa-stable-queens.vmlinuz \
    --driver-info deploy_ramdisk=https://tarballs.openstack.org/ironic-python-agent/tinyipa/files/tinyipa-stable-queens.gz \
    --deploy-interface direct \
    --os-baremetal-api-version=1.31 \
    -f value -c uuid`

#openstack baremetal port create aa:bb:cc:dd:00:00 --node 7781a721-59c5-439c-9b76-17674ce64a62
openstack baremetal port create aa:bb:cc:dd:00:00 --node ${NODE_UUID}

#OS_BAREMETAL_API_VERSION=1.31

openstack baremetal node set ${NODE_UUID} \
    --instance-info image_source=http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img \
    --instance-info root_gb=10 \
    --instance-info image_checksum=443b7623e27ecf03dc9e01ee93f67afe \
    --network-interface noop \
    --deploy-interface direct \
    --os-baremetal-api-version=1.31

openstack baremetal node validate ${NODE_UUID}

openstack baremetal node deploy ${NODE_UUID}

