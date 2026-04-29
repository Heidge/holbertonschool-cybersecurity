#!/bin/bash

update_repositories_and_packages() {
    export DEBIAN_FRONTEND=noninteractive
    
    # On vérifie l'update
    if apt-get update -y > "$BEAN"; then
        log "SYSTEM" "Update" "Success" "Repositories updated"
    else
        log "SYSTEM" "Update" "Error" "Failed to update repositories"
    fi
    
    # On vérifie l'upgrade
    #if apt-get upgrade -y > "$BEAN"; then
    #    log "SYSTEM" "Upgrade" "Success" "Packages upgraded"
    #else
    #    log "SYSTEM" "Upgrade" "Error" "Failed to upgrade packages"
    #fi
}

remove_insecure_bloatware() {
    # On tente la purge
    if apt-get purge -y telnet ftp netcat-traditional > "$BEAN"; then
        apt-get autoremove -y > "$BEAN"
        log "SYSTEM" "Bloatware" "Success" "Insecure packages purged"
    else
        log "SYSTEM" "Bloatware" "Error" "Failed to purge some bloatware"
    fi
}

install_security_tools() {
    # On tente l'installation
    if apt-get install -y auditd fail2ban > "$BEAN"; then
        log "SYSTEM" "Tools" "Success" "auditd and fail2ban installed"
    else
        log "SYSTEM" "Tools" "Error" "Failed to install security tools"
    fi
}
