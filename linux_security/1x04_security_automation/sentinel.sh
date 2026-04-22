#!/bin/bash
[[ -f sentinel.conf ]] && source sentinel.conf && [[ -n $SERVICES && -n $FILES_TO_WATCH ]] || { echo "Config Error"; exit 1; }

log() {
    echo -e "{\n\t\"timestamp\": $(date -u +\"%FT%TZ\"),\n\t\"component\": \"$1\",\n\t\"target\": \"$2\",\n\t\"status\": \"$3\",\n\t\"details\": \"$4\"\n}" >> /var/log/sentinel.log
}

check_services() {
    for svc in "${SERVICES[@]}"; do
        if pgrep -f "$svc" > /dev/null; then
            echo "OK: $svc is running"
            log "SERVICE" "$svc" "OK" "Is running"
        else
            if eval "$svc"; then
                echo "FIXED: Restarted $svc"
                log "SERVICE" "$svc" "FIXED" "Restarted service"
            else
                echo "ERROR: Failed to start $svc"
            fi
        fi
    done
}

check_services

check_integrity() {
    for file in "${FILES_TO_WATCH[@]}"; do
        filename=$(basename "$file")
        gold_file="/var/backups/sentinel/${filename}.gold"
        current_hash=$(md5sum "$file" | cut -d ' ' -f1)
        golden_hash=$(md5sum "$gold_file" | cut -d ' ' -f1)

        if [[ "$current_hash" == "$golden_hash" ]]; then
            echo "OK: $file integrity verified"
            log "INTEGRITY" "$file" "OK" "Integrity verified"
        else
            cp "$gold_file" "$file"
            echo "FIXED: Restored $file"
            log "INTEGRITY" "$file" "FIXED" "Restored file"
        fi
    done
}

check_integrity

check_ports() {
    current_ports=$(ss -lnt | grep -v "State" | awk '{print $4}' | cut -d':' -f2)

    for port in $current_ports; do
        is_allowed=false

        for allowed in "${ALLOWED_PORTS[@]}"; do
            if [[ "$port"=="$allowed_port" ]]; then
                is_allowed=true
                break
            fi
        done

        if [[ "$is_allowed"==false ]]; then
            fuser -k "$port/tcp" > /dev/null 2>&1
            echo "ALERT: Killed rogue process on port $port"
            log "PORT" "$port" "ALERT" "Killed rogue process"
        fi
    done
}

check_ports
