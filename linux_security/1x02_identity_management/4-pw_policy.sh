#!/bin/bash

apt-get update -y > /dev/null
apt-get install -y $1 > /dev/null

if grep -q "pam_pwquality.so" $2; then
    sed -i 's/pam_pwquality.so.*/pam_pwquality.so retry=3 minlen=12 minclass=3/' $2
else
    sed -i '/password.*pam_unix.so/i password requisite pam_pwquality.so retry=3 minlen=12 minclass=3' $2
fi
