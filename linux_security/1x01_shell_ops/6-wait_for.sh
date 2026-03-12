#!/bin/bash
until timeout 1  bash -c "cat < /dev/null > /dev/tcp/$1/80" 2>/dev/null; do
    echo "Waiting ..."
    sleep 1
done

echo "Service UP!"
