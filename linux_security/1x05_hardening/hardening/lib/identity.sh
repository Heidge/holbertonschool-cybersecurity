#!/bin/bash

set_password_policy() {
    #Set max age of the password
    sed -i "s/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   $PASS_MAX_DAYS/" "$USER_DEFS_CFG"
 
    #Install module libpam-pwquality for set password policy
    apt-get install -y libpam-pwquality > "$BEAN"
    
    #Set minimal length of the password
    sed -i "s/^#* *minlen =.*/minlen = $PASS_MIN_LEN/" $PWQ_FILE || echo "minlen = $PASS_MIN_LEN" >> $PWQ_FILE
    
    #Set rule for have minimum an upper, lower, digit and special character
    sed -i "s/^#* *minclass =.*/minclass = 4/" $PWQ_FILE || echo "minclass = 4" >> $PWQ_FILE
    
    #Edit pam file for apply policy
    if ! grep -q "pam_pwquality.so" "$PAM_PASS_CFG"; then
        sed -i '/pam_unix.so/i password requisite pam_pwquality.so retry=3' "$PAM_PASS_CFG"
    fi

    log "IDENTITY" "Password" "Success" "Password complexity and age policies applied."
}

set_account_lockout() {
    if ! grep -q "pam_faillock.so" "$AUTH_FILE"; then
        # Insert in first line a rule for check if user i lock with 5 attempts"
        sed -i '1i auth required pam_faillock.so preauth silent deny='$FAIL_LOCK_ATTEMPTS' unlock_time=1800' "$AUTH_FILE"
        
        # If authentication failsi (authfail), increase attemps of 1 with faillock module.
        sed -i '/auth.*pam_unix.so/a auth [default=die] pam_faillock.so authfail deny='$FAIL_LOCK_ATTEMPTS' unlock_time=1800' "$AUTH_FILE"
        
        # If authentication success, clean attempts counter
        sed -i '/auth.*pam_unix.so/a auth sufficient pam_faillock.so authsucc deny='$FAIL_LOCK_ATTEMPTS' unlock_time=1800' "$AUTH_FILE"
    fi

    # Check account informations like if locked, expired, rights etc
    if ! grep -q "pam_faillock.so" "$ACCOUNT_FILE"; then
        sed -i '1i account required pam_faillock.so' "$ACCOUNT_FILE"
    fi

    log "IDENTITY" "Lockout" "Success" "Account lockout policy applied at the top of PAM files."
}

cleanup_unprivileged_users() {
    log "IDENTITY" "Cleanup" "Info" "Starting cleanup of non-privileged users..."

    # Loop through user in passwd file and check if user is not nobody
    for user in $(awk -F: '$3 > 1000 && $1 != "nobody" {print $1}' "$PASSWD_FILE"); do

        # Check if user is in group sudo or wheel and if not delete its account
        if ! groups "$user" | grep -qE "\b({$GROUPS_NOLOCK})\b"; then
            log "IDENTITY" "Cleanup" "Info" "Deleting unprivileged user: $user"

            # Delete account and his personal directory
            userdel -r "$user" 2>"$BEAN"
        fi
    done

    log "IDENTITY" "Cleanup" "Success" "Non-privileged users cleanup finished."
}

lock_root_account() {
    passwd -l root > "$BEAN"
    log "IDENTITY" "Root" "Success" "Root account password locked. Use sudo for administrative tasks."
}
