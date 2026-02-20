#!/bin/bash

# Define users in an array
users=("user1" "user2" "user3")

# Default password
default_pass="TempPass123"

for user in "${users[@]}"; do
    # Add user
    useradd "$user"

    # Set default password
    echo "$user:$default_pass" | chpasswd

    # Force password change on first login
    passwd -e "$user"

    echo "User $user created with default password."
done
