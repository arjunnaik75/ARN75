#!/bin/bash

# Warning !! Safety First !
# Only for Non‑Production / LAB / Test Environment 
# Before running such commands:
# Make a backup of /etc/passwd, /etc/shadow, and /etc/group before deleting accounts.
# Double‑check the account you want to keep

# This will cleanup all user accounts and data having UID >= 1000 except accounts admin & arjun as excluded below: 
for user in $(awk -F: '($3 >= 1000) {print $1}' /etc/passwd | egrep -v '^(admin|arjun)$'); do
    sudo userdel -r "$user"
done

# This will cleanup all groups having GID >= 1000 except admin, admingroup & arjun as excluded below:
for group in $(awk -F: '($3 >= 1000) {print $1}' /etc/group | egrep -v '^(admin|admingroup|arjun)$'); do
    sudo groupdel "$group"
done
