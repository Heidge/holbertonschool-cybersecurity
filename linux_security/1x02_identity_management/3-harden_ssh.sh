#!/bin/bash

sed -i "s|^#*PermitRootLogin.*|PermitRootLogin no|" $1
sed -i "s|^#*PasswordAuthentication.*|PasswordAuthentication no|" $1
sed -i "s|^#*PubkeyAuthentication.*|PubkeyAuthentication yes|" $1

if sshd -t -f $1; then
    systemctl reload ssh
fi
