#!/bin/bash

setup_fw() {
    if [[ ! -d $FIREWALLRULES_DIRECTORY ]]; then
        sudo mkdir -p /etc/hardening
        log "NETWORK" "Firewall" "Success" "Firewall rules directory created"
    else
        log "NETWORK" "Firewall" "Failed" "Firewall rules direction already exists"
    fi   
}

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

apply_firewall_policy() {
    log "NETWORK" "Firewall" "Success" "Default incoming policy set to deny"
    echo "DEFAULT_INPUT=deny" > "$FIREWALL_RULES_FILE"
    log "NETWORK" "Firewall" "Success" "Default outgoing policy set to allow"
    echo "DEFAULT_OUTPUT=allow" >> "$FIREWALL_RULES_FILE"
}

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

harden_kernel_network() {
    sed -i 's/^#*net.ipv4.ip_forward.*/net.ipv4.ip_forward=0/' /etc/sysctl.conf
   
    if grep -q "net.ipv4.icmp_echo_ignore_all" /etc/sysctl.conf; then
        sed -i 's/^#*inet.ipv4.icmp_echo_ignore_all.*/net.ipv4.icmp_echo_ignore_all=1/' /etc/sysctl.conf
    else
        echo "net.ipv4.icmp_echo_ignore_all=1" >> /etc/sysctl.conf
    fi

    #sysctl -p > /dev/null
    
    log "NETWORK" "System" "Success" "Kernel network hardening applied (Forwarding off, Ping ignored)"
}
