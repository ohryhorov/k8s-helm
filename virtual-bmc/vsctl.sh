#!/bin/bash -xv

ovs-vsctl add-br br-simulator

ip tuntap add dev tap-bmt01-n0i1 mode tap; ip link set dev tap-bmt01-n0i1 up
ip tuntap add dev tap-bmt01-n0i2 mode tap; ip link set dev tap-bmt01-n0i2 up

ovs-vsctl add-port br-simulator tap-bmt01-n0i1
ovs-vsctl add-port br-simulator tap-bmt01-n0i2

ip ad del 192.168.90.9/24 dev ens4
ip ad add 192.168.90.9/24 dev br-simulator
ip link set up dev br-simulator
