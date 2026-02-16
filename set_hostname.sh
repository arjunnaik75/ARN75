#How to check hostname / RHEL Server Name
#hostnamectl status
#hostnamectl
hostname

#How to set hostname / RHEL Server Name Simple
#sudo hostnamectl set-hostname rhel.lab.local
hostnamectl hostname myserver.example.com
#hostnamectl set-hostname myserver.example.com

hostnamectl set-hostname "Web Server 01" --pretty

#vi /etc/hostname
#vi /etc/hosts
#vi /etc/sysconfig/network
#Entries Like: 
#127.0.0.1   myserver.example.com myserver
#HOSTNAME=myserver.example.com
#myserver.example.com

systemctl restart systemd-logind

