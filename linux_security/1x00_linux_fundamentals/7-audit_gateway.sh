#!/bin/bash
echo -e "#!/bin/bash\ncat /var/www/html/secret_config.php" > /usr/local/bin/audit-read-secret && setfacl -m u:"$1":r /usr/local/bin/audit-read-secret && echo "$1 ALL=(root) NOPASSWD: /usr/local/bin/audit-read-secret" > /etc/sudoers.d/audit-gate
