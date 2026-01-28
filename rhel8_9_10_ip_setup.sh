#!/bin/bash
# Script to set static IP on RHEL using nmcli

IFACE=eth0
IPADDR=192.168.1.100
PREFIX=24
GATEWAY=192.168.1.1
DNS1=192.168.1.1
DNS2=8.8.8.8
DNS3=8.8.4.4
DNS4=1.1.1.1

# Add connection if not exists
nmcli con add type ethernet ifname $IFACE con-name static-$IFACE

# Modify connection with static IP
nmcli con mod static-$IFACE ipv4.addresses $IPADDR/$PREFIX
nmcli con mod static-$IFACE ipv4.gateway $GATEWAY
nmcli con mod static-$IFACE ipv4.dns $DNS
nmcli con mod static-$IFACE ipv4.method manual

# Bring connection up
nmcli con up static-$IFACE
