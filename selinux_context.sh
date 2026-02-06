# 1. Set SELinux Context of httpd for non-default location or directory 
# If the desired location of webpages are non-deafult like /websites/public or /websites/private instead of default directory /var/www/html 
mkdir -p /websites/public
mkdir -p /websites/private
#Copy the websites into /websites/public or /websites/private
semanage fcontext -a -t httpd_sys_content_t "/websites(/.*)?"
restorecon -Rv /websites
ls -ldZ /websites
systemctl restart httpd

#curl "webpage"


# 2. Set SELinux Context for non-default (Ex-555) ssh port
# /etc/ssh/sshd_config  [Port 22 --> Port 555]
semanage port -l | grep 22
semanage port -a -t ssh_port_t -p tcp 555
semanage port -l | grep 555
systemctl restart sshd
netstat -tulpen | grep ssh
firewall-cmd --add-port=555/tcp --permanent
firewall-cmd --reload
firewall-cmd --list-all

#ssh -p 555 user@server_ip #to test 


# 3. Set SELinux Boolean for Samba
getsebool -a | grep samba
setsebool -P samba_export_all_rw 1
getsebool -a | grep samba
#setsebool -P samba_export_all_rw 0

