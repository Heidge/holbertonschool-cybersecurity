#!/bin/bash

log() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    if [[ $# -eq 1 ]]; then
        echo -e "\n\n$1 - $timestamp\n\n" >> "$LOG_PATH"
    else
        local component="$1"
        local target="$2"
        local status="$3"
        local details="$4"

        echo -e "{\n\t\"timestamp\": \"$timestamp\",\n\t\"component\": \"$component\",\n\t\"target\": \"$target\",\n\t\"status\": \"$status\",\n\t\"details\": \"$details\"\n}" >> "$LOG_PATH"

        local level="[INFO]"
        [[ "$status" == "Error" || "$status" == "Failed" ]] && level="[ERROR]"
        [[ "$status" == "Warning" ]] && level="[WARN]"

        echo "$level $details" >> "$REPORT_FILE.tmp"
    fi
}

generate_audit_report() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    local status="PASS"
    
    if grep -q "\[ERROR\]" "$REPORT_FILE.tmp"; then
        status="FAIL"
    fi

    {
        echo "==============================================="
        echo " HARDENING AUDIT REPORT - $timestamp"
        echo "==============================================="
        echo ""
        cat "$REPORT_FILE.tmp"
        echo ""
        echo "==============================================="
        echo " COMPLIANCE STATUS: $status"
        echo "==============================================="
    } > "$REPORT_FILE"

    rm -f "$REPORT_FILE.tmp"
    
    echo -e "Audit report generated: $REPORT_FILE"
}
