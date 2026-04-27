#!/bin/bash

if [[ $EUID -ne 0 ]]; then 
    echo "You must be root for execute this script"
    exit 1
fi

# Load config file and libraries
source ./config/harden.cfg
source ./lib/utils.sh
source ./lib/network.sh
source ./lib/ssh.sh

log "Hardening framework initialized"

#setup_ufw
apply_firewall_policy
open_allowed_ports
harden_kernel_network
harden_ssh

