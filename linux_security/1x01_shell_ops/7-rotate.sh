#!/bin/bash
if [ ! -d "$1" ]; then
    exit 1
fi

mkdir -p "$1/backups"

for log_file in $1/*.log; do
    filename=$(basename "$log_file")
    size=$(stat -c%s "$log_file")
    
    if [ "$size" -gt 1024 ]; then
        gzip "$log_file"
        mv "${log_file}.gz" $1/backups
    else
        echo "Skipping small file: $filename"
    fi
done
