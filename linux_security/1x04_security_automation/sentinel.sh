#!/bin/bash
[[ -f sentinel.conf ]] && source sentinel.conf && [[ -n $SERVICES && -n $FILES_TO_WATCH ]] || { echo "Config Error"; exit 1; }

check_services() {
    for svc in "${SERVICES[@]}"; do
        if pgrep -f "$svc"; then
            echo "OK: $svc is running"
        else
            if eval "$svc"; then
                echo "FIXED: Restarted $svc"
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
        else
            cp "$gold_file" "$file"
            echo "FIXED: Restored $file"
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
        fi
    done
}

check_ports
