# Find the interface like enp2s0
nmcli | egrep 'eth|en|interface'

# Modify connection with static IP
nmcli con mod enp2s0 ipv4.addresses 192.168.1.100/24
nmcli con mod enp2s0 ipv4.gateway 192.168.1.1
nmcli con mod enp2s0 ipv4.dns 192.168.1.1
#nmcli con mod enp2s0 ipv4.dns "192.168.1.1 8.8.8.8 8.8.4.4 1.1.1.1"
nmcli con mod enp2s0 ipv4.method manual
nmcli con mod ens160 connection.autoconnect yes

# Bring connection up
nmcli con up enp2s0
# Reload connection / Restart Netwotk Manager
nmcli connection reload ens160
systemctl restart NetworkManager

# Verify
ip a s enp2s0 > ip.txt && cat /etc/resolv.conf >> ip.txt
cat ip.txt



