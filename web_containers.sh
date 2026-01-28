# To Host Multiple Websites with Podman Containers using a single Host_Server
# Website_01 using httpd over 8282:8080 and Website_02 over 8383:80 using nginx
# Setup a Host_Machine (In my case : RHEL8.9, rhel.lab.local, 192.168.1.10/24, anaik <root is root>)

# Create the directory and place the Web_Contents for the user 
# In my case : for site01 <blackhol.html and blackhol.jpg>, for site02 <earth.tml and earth.jpg>
mkdir -p /home/anaik/wpages/site{01,02}
chown -R anaik:anaik /home/anaik/wpages/
chmod -R 755 /home/anaik/wpages/
ls -ltrdZ /home/anaik/wpages/
semanage fcontext -a -t httpd_sys_content_t '/wpages(/.*)?'
#semanage fcontext -a -t httpd_sys_rw_content_t "/wpages/site01(/.*)?" 
#semanage fcontext -a -t httpd_sys_rw_content_t "/wpages/site02(/.*)?" 
restorecon -Rv /wpages

# Optional Config Files for Tesing on the Local Host Machine /etc/httpd/conf/httpd.conf and /etc/httpd/conf.d/mysites.conf
# Repositories Config Files /etc/yum.repo.d/redhat.repo and /etc/containers/registries.conf
ls -ltrdZ /home/anaik/wpages/
ls -ltrdZ /home/anaik/wpages/site01
dnf install podman -y
podman login registry.redhat.io
podman search httpd
grep anaik /etc/subuid
grep anaik /etc/subgid
sudo sh -c 'echo "anaik:100000:65536" >> /etc/subuid‘
sudo sh -c 'echo "anaik:100000:65536" >> /etc/subgid'
sudo loginctl enable-linger anaik
podman system migrate

#Setup for 1st Container (httpd with custom webpage) #Copy the web contents into /home/anaik/wpages/site01
dnf install policycoreutils-python-utils
semanage port -l
semanage port -a -t http_port_t -p tcp 8282
getenforce
setenforce 1
sudo sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
firewall-cmd --list-all
firewall-cmd --add-service=http --permanent 
firewall-cmd –-add-port=8282/tcp –-permanent
firewall-cmd --reload

podman login registry.redhat.io --get-login
podman search httpd
skopeo inspect docker://registry.redhat.io/rhel9/httpd-24
podman pull registry.redhat.io/rhel9/httpd-24
podman images
podman run -dt --name http -p 8282:8080 -v /home/anaik/wpages/site01:/var/www/html:Z registry.redhat.io/rhel9/httpd-24
podman ps
podman ps -a

mkdir -p ~/.config/systemd/user
sudo chown -R anaik:anaik ~/.config/systemd/user
#ls -ltrdZ /home/anaik/.config/systemd/user
#chmod 775  ~/.config/systemd/user
ls -ld ~/.config/systemd/user
systemctl --user daemon-reload
systemctl --user enable --now podman.socket
systemctl --user status podman.socket
podman generate systemd --name httpd --files --user
#podman generate systemd --name httpd --files
cp /home/anaik/container-httpd.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now container-httpd.service
systemctl --user status container-httpd.service

apachectl configtest
podman exec -it httpd bash 
curl http://rhel.lab.local:8282/blackhole.html
# Browse http://rhel.lab.local:8282/blackhole.html
# ############################################################# #

#Setup for 2nd Container (nginx with custom webpage)
#Copy the web contents into /home/anaik/wpages/site02
ls -ltrdZ /home/anaik/wpages/
ls -ltrdZ /home/anaik/wpages/site02
semanage port -l
semanage port -a -t http_port_t -p tcp 8383
firewall-cmd --list-all
firewall-cmd –-add-port=8383/tcp –-permanent
firewall-cmd --reload

podman search nginx
skopeo inspect docker://docker.io/library/nginx:latest 
podman pull docker.io/library/nginx:latest 
podman images
podman run -dt --name nginx -p 8383:80 -v /home/anaik/wpages/site02:/usr/share/nginx/html:Z docker.io/library/nginx:latest 
podman ps
podman generate systemd --name nginx --files --user
#podman generate systemd --name nginx --files
cp /home/anaik/container-nginx.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now container-nginx.service
systemctl --user status container-nginx.service

podman exec -it nginx
curl http://rhel.lab.local:8383/earth.html
#Browse http://rhel.lab.local:8383/earth.html

systemctl --user status container-nginx.service
systemctl --user status container-httpd.service
podman ps

# ################################################ #
# 2 Containers are now serving 2 different Websites using a single Host_Server
podman login registry.redhat.io --get-login
podman login registry.access.redhat.com --get-login
podman logout registry.access.redhat.com
podman logout registry.redhat.io

# ################################################ #
# Troubleshooting Steps #
apachectl configtest
podman ps
podman ps -a
#sudo ss -ltnp | grep -E '8282|8383'
#sudo netstat -tulpn | grep -E '8282|8383'
#journalctl --user -u container-nginx.service
#journalctl --user -u container-http.service
#podman-remote --url unix:///run/user/$UID/podman/podman.sock info
#podman exec -it httpd ls /var/www/html
#podman exec -it nginx ls /usr/share/nginx/html
#nginx volume mapping: /var/www/html:Z for RHEL Images,  usr/share/nginx/html:Z for Docker Images.
#systemctl --user daemon-reload
#systemctl --user stop container-httpd.service
#systemctl --user restart container-httpd.service
#systemctl --user stop container-nginx.service
#systemctl --user restart container-nginx.service
#systemctl --user status container-nginx.service
#systemctl --user status container-httpd.service
#podman inspect nginx | grep User
#podman exec -it --user 1000 nginx bash
#podman inspect httpd | grep User
#podman exec -it --user 1000 httpd bash

tail -f /etc/httpd/logs/site01-error.log
tail -f /etc/httpd/logs/access_log
tail -f /var/log/nginx/access.log
ps aux | grep httpd
ps aux | grep nginx
ss -tlnp | grep httpd
 
#ls -ld ~/.config/systemd/user
#sudo chown -R anaik:anaik ~/.config/systemd/user
#rm -f ~/.config/systemd/user/podman.socket
#rm -f ~/.config/systemd/user/podman.service


#systemctl --user disable --now container-nginx.service
#systemctl --user disable --now container-httpd.service
#podman stop <container>
#podman rm -f <container>

cat /etc/httpd/conf/httpd.conf
cat /etc/httpd/conf.d/mysites.conf
cat /etc/hosts










 



  


