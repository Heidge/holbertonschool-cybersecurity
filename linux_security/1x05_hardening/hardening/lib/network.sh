#!/bin/bash

setup_ufw() {
    # Replace IPV6=no by IPV6=yes if needed
    sed -i 's/^IPV6=.*/IPV6=yes/' /etc/default/ufw

    apt update && sudo apt install ufw

    ufw --force enable

    if ufw status | grep -q "active"; then
        log "NETWORK" "Firewall" "Sucess" "UFW is active"
    else
        log "NETWORK" "Firewall" "Error" "UFW failed to start"
    fi
}

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

}

harden_kernel_network() {

}
