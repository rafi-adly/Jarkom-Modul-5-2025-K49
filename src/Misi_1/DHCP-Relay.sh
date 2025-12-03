#!/bin/bash
# FILE: /root/dhcp-relay.sh

apt-get update
apt-get install isc-dhcp-relay -y

cat > /etc/default/isc-dhcp-relay << 'EOF'
SERVERS="10.88.2.202"  # IP Vilya
INTERFACES="eth0 eth1 eth2"
OPTIONS=""
EOF

service isc-dhcp-relay restart
echo "DHCP Relay ready!"
