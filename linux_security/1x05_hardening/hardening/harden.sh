#!/bin/bash

if [[ $EUID -ne 0 ]]; then 
    echo "You must be root for execute this script"
    exit 1
fi

# Load config file and libraries
source ./config/harden.cfg
source ./lib/utils.sh

log "Hardening framework initialized"
