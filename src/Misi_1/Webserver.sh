#!/bin/bash
# FILE: /root/webserver.sh

apt-get update
apt-get install apache2 -y

HOSTNAME=$(hostname)
cat > /var/www/html/index.html << EOF
Welcome to $HOSTNAME
EOF

service apache2 start
echo "Web Server $HOSTNAME ready!"

# Testing: curl http://10.88.2.246 (Palantir)
# Testing: curl http://10.88.2.226 (IronHills)
