#!/bin/bash
while read -r user; do
    if id "$user" &>/dev/null; then
        passwd -l "$user" &>/dev/null
        echo "User $user locked"
    else
        echo "User $user not found"
    fi
done < $1
