#!/bin/bash

CONF_FILE='/etc/dnsmasq.d/ironic-dnsmasq.conf'
ADDHOSTS_FILE='/etc/dnsmasq.d/ironic.addnhosts'
HOSTS_FILE='/etc/dnsmasq.d/ironic.hostsfile'

if [ ! -f ${ADDHOSTS_FILE} ]; then
    touch ${ADDHOSTS_FILE}
fi

if [ ! -f ${HOSTS_FILE} ]; then
    touch ${HOSTS_FILE}
fi

if [ ! -f ${CONF_FILE} ]; then
    cp /srv/k8s-helm/virtual-bmc/ironic-dnsmasq.conf ${CONF_FILE}
fi

dnsmasq --conf-file=${CONF_FILE} --log-dhcp
