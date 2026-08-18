#!/bin/bash

harden_ssh() {
    if [ -f "$SSH_CFG" ]; then

        #Disable password and enable public key auth
        sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' "$SSH_CFG"
        sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' "$SSH_CFG"
        log "SSH" "Password" "Success" "Password auth disabled, Key auth enabled"
        
        #Disable root login
        sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' "$SSH_CFG"
        log "SSH" "Connection" "Success" "Root login disabled"
        
        # Check if file well edited
        if sshd -t; then
            log "SSH" "Check" "Success" "sshd_config syntax is valid"
        else
            log "SSH" "Check" "Error" "sshd_config syntax error!"
        fi
    else
        log "SSH" "Config" "Error" "$SSH_CFG not found"
    fi
}
