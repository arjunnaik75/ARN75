# Creating multiple users and assigning common supplimentary group

# Create Group Name: devteam
if ! getent group devteam > /dev/null; then
sudo groupadd devtaem
fi

getent group | grep devteam

# Check the default configuration
sudo cat /etc/login.defs
sleep 6
sudo cat /etc/default/useradd
sleep 6

# Choose the parameters -m and -s based on the default configuration

# Create User01 and set default password
if ! id user01 > /dev/null; then
sudo useradd -G devtaem user01
echo "redhat" | sudo passwd user01
fi

# Create User02 and set default password
if ! id user02 > /dev/null; then
sudo useradd -m -s /bin/bash -G devtaem user02
echo "redhat" | sudo passwd --stdin user02
fi

# Create User03 and set default password
if ! id user03 > /dev/null; then
sudo useradd -m -s /bin/bash -G devtaem user03
echo "redhat" | sudo passwd --stdin user03
fi

# ########################################## #

# Status (Optional)
echo "Group created : devteam"
sleep 1
echo "Users created : user01, user02, user03"
sleep 1
echo "Users added in devteam"
sleep 1
echo "Default password set for all users : redhat"
sleep 3
# Verify
grep "^devteam" /etc/group

