#!/bin/bash

# Log function for trace every status and actions of hardening
log() {
    if [[ $# -eq 1 ]];then
        echo -e "\n\n$1 - $(date -u +%FT%TZ)\n\n" >> $LOG_PATH
    else
        echo -e "{\n\t\"timestamp\": \"$(date -u +%FT%TZ)\",\n\t\"component\": \"$1\",\n\t\"target\": \"$2\",\n\t\"status\": \"$3\",\n\t\"details\": \"$4\"\n}" >> $LOG_PATH
    fi
}

