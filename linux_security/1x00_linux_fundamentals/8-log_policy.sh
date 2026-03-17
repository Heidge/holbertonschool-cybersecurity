#!/bin/bash
chown root:$2 $1 && chmod 2750 $1 && echo -e "$1*.log {\n\tcreate 0640 root $2\n}" > /etc/logrotate.d/app
