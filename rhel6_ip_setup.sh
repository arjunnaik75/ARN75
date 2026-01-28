#!/bin/bash
# Script to set static IP by editing ifcfg file

IFACE=eth0
CFG=/etc/sysconfig/network-scripts/ifcfg-$IFACE

cat <<EOF | sudo tee $CFG
DEVICE=$IFACE
BOOTPROTO=static
ONBOOT=yes
IPADDR=192.168.1.100
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=8.8.8.8
EOF

# Restart network service
sudo systemctl restart network
