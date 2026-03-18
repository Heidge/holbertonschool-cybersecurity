#!/bin/bash
[[ -f sentinel.conf ]] && source sentinel.conf && [[ -n $SERVICES && -n $FILES_TO_WATCH ]] || { echo "Error: Config invalid or missing"; exit 1; }
