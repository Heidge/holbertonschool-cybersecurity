#!/bin/bash

awk -F: '$3 >= 1000 { print $1 }' $1 | while read -r user; do
    user_groups=$(id -Gn $user 2>/dev/null)

    for group in disk docker shadow; do
        if echo $user_groups | grep -qw $group; then
            echo $user:$group
        fi
    done

done
