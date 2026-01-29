if ! getent group devteam > /dev/null; then
sudo groupadd devteam 
fi

for user in aws1 aws2 aws3 aws4 aws5; do
    sudo useradd -m -s /bin/bash -G devteam "$user"
    echo "Password@#123" | sudo passwd --stdin "$user"
    sudo passwd -e "$user"
    sudo chage -M 90 -m 7 -W 14 "$user"
done

cat /etc/passwd | grep aws
sleep 4
getent group | grep devteam
