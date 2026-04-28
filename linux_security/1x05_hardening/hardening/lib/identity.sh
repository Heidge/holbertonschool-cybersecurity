#!/bin/bash

set_password_policy() {
    #Set max age of the password
    sed -i "s/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   $PASS_MAX_DAYS/" /etc/login.defs
 
    #Install module libpam-pwquality for set password policy
    apt-get install -y libpam-pwquality > /dev/null
    
    #Set minimal length of the password
    sed -i "s/^#* *minlen =.*/minlen = $PASS_MIN_LEN/" $PWQ_FILE || echo "minlen = $PASS_MIN_LEN" >> $PWQ_FILE
    
    #Set rule for have minimum an upper, lower, digit and special character
    sed -i "s/^#* *minclass =.*/minclass = 4/" $PWQ_FILE || echo "minclass = 4" >> $PWQ_FILE
    
    #Edit pam file for apply policy
    if ! grep -q "pam_pwquality.so" /etc/pam.d/common-password; then
        sed -i '/pam_unix.so/i password requisite pam_pwquality.so retry=3' /etc/pam.d/common-password
    fi

    log "IDENTITY" "Password" "Success" "Password complexity and age policies applied."
}


