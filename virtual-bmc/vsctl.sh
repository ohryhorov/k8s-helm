ip tuntap add dev tap-bmt01-n0i1 mode tap; ip link set dev tap-bmt01-n0i1 up
ip tuntap add dev tap-bmt01-n0i2 mode tap; ip link set dev tap-bmt01-n0i2 up

ovs-vsctl add-br br-baremetal

ovs-vsctl add-port br-simulator tap-bmt01-n0i1
ovs-vsctl add-port br-simulator tap-bmt01-n0i2

