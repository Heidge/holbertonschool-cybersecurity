#!/bin/bash
chown :"$2" "$1" && chmod 2740 "$1" && echo -e "$1*.log {\n\tcreate 0640 root www-data\n}" >> /etc/logrotate.d/app
