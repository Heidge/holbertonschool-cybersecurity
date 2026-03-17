#!/bin/bash

echo "$1 ALL=(ALL) /usr/bin/systemctl restart apache2, /usr/bin/journalctl" > /etc/sudoers.d/junior

chmod 440 /etc/sudoers.d/junior

if visudo -c; then
    exit 0
else
    rm /etc/sudoers.d/junior
    exit 1
fi
