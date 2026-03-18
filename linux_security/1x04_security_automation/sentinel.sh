#!/bin/bash
[[ -f sentinel.conf ]] && source sentinel.conf && [[ -n $SERVICES ]] || { echo "Config Error"; exit 1; }
check_services() { for svc in "${SERVICES[@]}"; do pgrep -x "$svc" >/dev/null && logger "OK: $svc is running" || { eval "systemctl start $svc" && logger "FIXED: Restarted $svc" || logger "ERROR: Failed to start $svc"; }; done; }; check_services
