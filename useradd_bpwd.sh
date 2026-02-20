#!/bin/bash

# List of users
users=("user1" "user2" "user3")

for user in "${users[@]}"; do
    # Create user
    useradd "$user"

    # Remove password (blank)
    passwd -d "$user"

    # Expire password immediately
    passwd -e "$user"

    echo "User $user created with blank password, must change at first login."
done
