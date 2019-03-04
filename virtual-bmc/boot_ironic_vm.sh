vbmc add bmt01-n0 --port 6200
vbmc start bmt01-n0
vbmc show bmt01-n0

virsh pool-define-as --name default dir --target /var/lib/libvirt/images && virsh pool-autostart default && virsh pool-start default
virsh vol-create-as default bmt01-n0.qcow2 --capacity 10G --format qcow2

virsh pool-info default

virsh define /tmp/bmt01-n0.xml

openstack baremetal node create --driver ipmi \
    --driver-info ipmi_address=192.168.90.9 \
    --driver-info ipmi_port=6200 \
    --driver-info ipmi_username=admin \
    --driver-info ipmi_password=password \
    --driver-info deploy_kernel=https://tarballs.openstack.org/ironic-python-agent/tinyipa/files/tinyipa-stable-queens.vmlinuz \
    --driver-info deploy_ramdisk=https://tarballs.openstack.org/ironic-python-agent/tinyipa/files/tinyipa-stable-queens.gz

openstack baremetal port create aa:bb:cc:dd:00:00 --node 7781a721-59c5-439c-9b76-17674ce64a62

OS_BAREMETAL_API_VERSION=1.31

openstack baremetal node set 7781a721-59c5-439c-9b76-17674ce64a62 \
    --instance-info image_source=http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img \
    --instance-info root_gb=10 \
    --instance-info image_checksum=443b7623e27ecf03dc9e01ee93f67afe \
    --deploy-interface direct \
    --network-interface noop

openstack baremetal node validate 7781a721-59c5-439c-9b76-17674ce64a62

openstack baremetal node deploy 7781a721-59c5-439c-9b76-17674ce64a62
