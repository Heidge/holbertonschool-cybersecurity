#!/bin/bash

update_repositories_and_packages() {
    export DEBIAN_FRONTEND=noninteractive
    
    apt-get update -y 
   # if [[ $(apt-get -s upgrade | grep -c "^Inst") -eq 0 ]]; then
   #     log "System" "Upgrade" "Success" "Packages already up to date"
   # else
   #     apt-get upgrade -y
   #     log "System" "Upgrade" "Success" "Packages upgraded successfully"
   # fi
}

remove_insecure_bloatware() {
    apt-get purge -y telnet ftp netcat-traditional
    apt-get autoremove -y
    log "System" "Bloatware" "Success" "Insecure packages (telnet, ftp, netcat) purged"
}

install_security_tools() {
    apt-get install -y auditd fail2ban
    log "System" "Tools" "Success" "auditd and fail2ban installed"
}
