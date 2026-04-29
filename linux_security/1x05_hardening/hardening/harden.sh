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
source ./lib/identity.sh
source ./lib/system.sh

log "Hardening framework initialized"

# Network domain security applications
setup_fw
#setup_ufw
apply_firewall_policy
open_allowed_ports
harden_kernel_network

# SSH security applications
harden_ssh

# Identity domain security applications
set_password_policy
set_account_lockout
cleanup_unprivileged_users
lock_root_account

# System secruity applications
update_repositories_and_packages
remove_insecure_bloatware
install_security_tools

# Audit report generation
generate_audit_report
