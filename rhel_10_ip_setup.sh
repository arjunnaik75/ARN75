#dnf install NetworkManager -y

#IPv4 on enp0s3
#nmcli connnection add con-name enp0s3 type ethernet ifname enp0s3 ipv4.addresses 192.168.1.11/24 ipv4.gateway 192.168.1.1 ipv4.dns "192.168.1.1 8.8.8.8" ipv4.method manual
nmcli connnection modify enp0s3 ipv4.addresses 192.168.1.11/24 ipv4.gateway 192.168.1.1 ipv4.dns 192.168.1.5 ipv4.method manual
#nmcli connnection modify enp0s3 ipv4.dns "192.168.1.5 192.168.1.6 8.8.8.8"
#nmcli connnection modify enp0s3 ipv4.dns-search example.com
#nmcli connnection modify enp0s3 ipv4.routes "10.1.1.0/24 192.168.1.254"

#IPv6 on enp0s3
#nmcli connnection modify enp0s3 ipv6.addresses 2020::1/64 ipv6.method manual

nmcli connnection reload enp0s3
nmcli connnection up enp0s3
cat /etc/NetworkManager/system-connections/enp0s3.nmconnection | tee -a /tmp/enp0s3_status.txt
#vi /etc/NetworkManager/system-connections/enp0s3.nmconnection
systemctl restart NetworkManager

#Verify
nmcli | grep enp0s3 >> /tmp/enp0s3_status.txt
nmcli connection show >> /tmp/enp0s3_status.txt
ip address show | grep enp0s3 >> /tmp/enp0s3_status.txt
ip address show >> /tmp/enp0s3_status.txt
ip link show >> /tmp/enp0s3_status.txt
ip route show >> /tmp/enp0s3_status.txt
route -n >> /tmp/enp0s3_status.txt
cat /etc/resolve.conf >> /tmp/enp0s3_status.txt
cat /etc/hosts >> /tmp/enp0s3_status.txt
ping -c 4 192.168.1.1 >> /tmp/enp0s3_status.txt
ping -c 4 192.168.1.5 >> /tmp/enp0s3_status.txt
ping -c 4 www.google.com >> /tmp/enp0s3_status.txt
getent hosts 192.168.1.5 >> /tmp/enp0s3_status.txt
getent hosts s1.example.com >> /tmp/enp0s3_status.txt
nslookup s1.example.com >> /tmp/enp0s3_status.txt
nslookup 192.168.1.11 >> /tmp/enp0s3_status.txt
nslookup 192.168.1.5 >> /tmp/enp0s3_status.txt



