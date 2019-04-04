#!/bin/bash -xv

export OS_TOKEN=fake-token
export OS_URL=http://ironic.openstack.svc.cluster.local:80

virsh vol-create-as default bmt01-n0.qcow2 --capacity 10G --format qcow2

virsh pool-info default

virsh define /srv/k8s-helm/virtual-bmc/bmt01-n0.xml

vbmc add bmt01-n0 --port 6200
vbmc start bmt01-n0
vbmc show bmt01-n0

simulator_ip="$(ip a | awk -v prefix="^    inet 192.168.90" '$0 ~ prefix {split($2, a, "/"); print a[1]}' | head -1)"

NODE_UUID=`openstack baremetal node create --driver ipmi \
    --driver-info ipmi_address=${simulator_ip} \
    --driver-info ipmi_port=6200 \
    --driver-info ipmi_username=admin \
    --driver-info ipmi_password=password \
    --driver-info deploy_kernel=https://tarballs.openstack.org/ironic-python-agent/tinyipa/files/tinyipa-stable-queens.vmlinuz \
    --driver-info deploy_ramdisk=https://tarballs.openstack.org/ironic-python-agent/tinyipa/files/tinyipa-stable-queens.gz \
    --deploy-interface direct \
    --os-baremetal-api-version=1.31 \
    -f value -c uuid`

if [ -z ${NODE_UUID} ]; then
   echo "Baremetal node has not been created"
   exit 1
else
   openstack baremetal port create aa:bb:cc:dd:00:00 --node ${NODE_UUID}

   openstack baremetal node set ${NODE_UUID} \
        --instance-info image_source=http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img \
        --instance-info root_gb=10 \
        --instance-info image_checksum=443b7623e27ecf03dc9e01ee93f67afe \
        --network-interface noop \
        --deploy-interface direct \
        --os-baremetal-api-version=1.31

   openstack baremetal node validate ${NODE_UUID}

   openstack baremetal node manage ${NODE_UUID} --os-baremetal-api-version=1.31

   openstack baremetal node provide ${NODE_UUID} --os-baremetal-api-version=1.31

   openstack baremetal node deploy ${NODE_UUID} --os-baremetal-api-version=1.31
fi
