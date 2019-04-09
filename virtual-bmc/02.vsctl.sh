#!/bin/bash -xv

baremetal_ip="$(ip a | awk -v prefix="^    inet 192.168.90" '$0 ~ prefix {split($2, a, "/"); print a[1]}' | head -1)"
baremetal_network="$(ip a | awk -v prefix="^    inet 192.168.90" '$0 ~ prefix {split($2, a, "/"); print a[2]}'| head -1)"
baremetal_iface="$(ip a | awk -v prefix="^    inet 192.168.90" '$0 ~ prefix {split($7, a, "/"); print a[1]}'| head -1)"

ovs-vsctl add-br br-simulator

ip ad del ${baremetal_ip}/${baremetal_network} dev ${baremetal_iface}
ip ad add ${baremetal_ip}/${baremetal_network} dev br-simulator

ip tuntap add dev tap-bmt01-n0i1 mode tap; ip link set dev tap-bmt01-n0i1 up
ip tuntap add dev tap-bmt01-n0i2 mode tap; ip link set dev tap-bmt01-n0i2 up

ovs-vsctl add-port br-simulator tap-bmt01-n0i1
ovs-vsctl add-port br-simulator tap-bmt01-n0i2

ip link set up dev br-simulator
