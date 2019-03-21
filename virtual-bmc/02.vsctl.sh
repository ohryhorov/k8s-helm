#!/bin/bash -xv

ens4_ip="$(ip a | awk -v prefix="^    inet 192.168.90" '$0 ~ prefix {split($2, a, "/"); print a[1]}' | head -1)"
ens4_network="$(ip a | awk -v prefix="^    inet 192.168.90" '$0 ~ prefix {split($2, a, "/"); print a[2]}'| head -1)"

ovs-vsctl add-br br-simulator

ip ad del ${ens4_ip}/${ens4_network} dev ens4
ip ad add ${ens4_ip}/${ens4_network} dev br-simulator

ip tuntap add dev tap-bmt01-n0i1 mode tap; ip link set dev tap-bmt01-n0i1 up
ip tuntap add dev tap-bmt01-n0i2 mode tap; ip link set dev tap-bmt01-n0i2 up

ovs-vsctl add-port br-simulator tap-bmt01-n0i1
ovs-vsctl add-port br-simulator tap-bmt01-n0i2

ip link set up dev br-simulator
