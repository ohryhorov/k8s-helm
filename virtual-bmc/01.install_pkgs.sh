#!/bin/bash -xv

echo "deb [arch=amd64] http://mirror.mirantis.com/testing//openstack-pike//xenial xenial main" >> /etc/apt/sources.list
curl http://mirror.mirantis.com/testing//openstack-pike/xenial/archive-pike.key | apt-key add -

apt update

apt install -y qemu qemu-kvm python-pip openvswitch-switch python-libvirt libvirt-bin pkg-config python-ironicclient

pip install virtualbmc

#disable libvirt networking
virsh net-list && virsh net-destroy default && virsh net-autostart --network default --disable
virsh pool-define-as --name default dir --target /var/lib/libvirt/images && virsh pool-autostart default && virsh pool-start default

