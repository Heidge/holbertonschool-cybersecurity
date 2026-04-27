#!/bin/bash

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
    ufw default deny incoming > /dev/null
    if [[ $? -eq 0 ]]; then
        log "NETWORK" "Firewall" "Sucess" "Default incoming policy set to deny"
        echo "DEFAULT_INPUT=deny" > "$FIREWALL_RULES_FILE"
    else
        log "NETWORK" "Firewall" "Error" "Failed to set default incoming policy"
    fi

    ufw default allow outgoing > /dev/null
    if [[ $? -eq 0 ]]; then
        log "NETWORK" "Firewall" "Success" "Default ingoing policy set to allow"
    echo "DEFAULT_OUTPUT=allow" >> "$FIREWALL_RULES_FILE"
    else
        log "NETWORK" "Firewall" "Error" "Failed to set default ingoing policy"
    fi 
}

open_allowed_ports() {
    ufw allow "${SSH_PORT}/tcp" > /dev/null
    echo "ALLOW_TCP=$SSH_PORT" >> "$FIREWALL_RULES_FILE"
    log "NETWORK" "Firewall" "Success" "SSH port $SSH_PORT allowed"

    ufw allow "${HTTP_PORT}/tcp" > /dev/null
    echo "ALLOW_TCP=$HTTP_PORT" >> "$FIREWALL_RULES_FILE"
    log "NETWORK" "Firewall" "Success" "HTTP port $HTTP_PORT allowed"

    ufw allow "${HTTPS_PORT}/tcp" > /dev/null
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

    sysctl -p > /dev/null
    
    log "NETWORK" "System" "Success" "Kernel network hardening applied (Forwarding off, Ping ignored)"
}
