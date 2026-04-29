#!/bin/bash

# Create a directory where firewall rules file will be
setup_fw() {
    if [[ ! -d $FIREWALLRULES_DIRECTORY ]]; then
        sudo mkdir -p /etc/hardening
        log "NETWORK" "Firewall" "Success" "Firewall rules directory created"
    else
        log "NETWORK" "Firewall" "Failed" "Firewall rules direction already exists"
    fi   
}

# Install ufw and active it
#setup_ufw() {
#    apt update && apt install ufw
#
#    ufw --force enable
#
#    if ufw status | grep -q "active"; then
#        log "NETWORK" "Firewall" "Sucess" "UFW is active"
#    else
#        log "NETWORK" "Firewall" "Error" "UFW failed to start"
#    fi
#}

# Write firewall rules about incoming and outgoing trafic policy in firewall rules file
apply_firewall_policy() {
    log "NETWORK" "Firewall" "Success" "Default incoming policy set to deny"
    echo "DEFAULT_INPUT=deny" > "$FIREWALL_RULES_FILE"
    log "NETWORK" "Firewall" "Success" "Default outgoing policy set to allow"
    echo "DEFAULT_OUTPUT=allow" >> "$FIREWALL_RULES_FILE"
}

# Allow SSH, HTTP and HTTPS ports trafic
open_allowed_ports() {
    # SSH
    echo "ALLOW_TCP=$SSH_PORT" >> "$FIREWALL_RULES_FILE"
    log "NETWORK" "Firewall" "Success" "SSH port $SSH_PORT allowed"

    # HTTP
    echo "ALLOW_TCP=$HTTP_PORT" >> "$FIREWALL_RULES_FILE"
    log "NETWORK" "Firewall" "Success" "HTTP port $HTTP_PORT allowed"

    # HTTPS
    echo "ALLOW_TCP=$HTTPS_PORT" >> "$FIREWALL_RULES_FILE"
    log "NETWORK" "Firewall" "Success" "HTTPS port $HTTPS_PORT allowed"
}

# Ignore forwarding ip and ping 
harden_kernel_network() {
    sed -i 's/^#*net.ipv4.ip_forward.*/net.ipv4.ip_forward=0/' "$SYSCTL_CONF"
   
    if grep -q "net.ipv4.icmp_echo_ignore_all" "$SYSCTL_CONF"; then
        sed -i 's/^#*inet.ipv4.icmp_echo_ignore_all.*/net.ipv4.icmp_echo_ignore_all=1/' "$SYSCTL_CONF"
    else
        echo "net.ipv4.icmp_echo_ignore_all=1" >> "$SYSCTL_CONF"
    fi

    #sysctl -p > "$BEAN"
    
    log "NETWORK" "Kernel" "Success" "Kernel network hardening applied (Forwarding off, Ping ignored)"
}
