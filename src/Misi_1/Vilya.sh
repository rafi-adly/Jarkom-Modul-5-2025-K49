#!/bin/bash
# FILE: /root/dhcp.sh

apt-get update
apt-get install isc-dhcp-server -y

echo 'INTERFACESv4="eth0"' > /etc/default/isc-dhcp-server

cat > /etc/dhcp/dhcpd.conf << 'EOF'
option domain-name "aliansi.k49.com";
option domain-name-servers 10.88.2.203; # Narya
default-lease-time 600;
max-lease-time 7200;
authoritative;
ddns-update-style none;

# A4 - Khamul (5 host)
subnet 10.88.2.192 netmask 255.255.255.248 {
    range 10.88.2.194 10.88.2.198;
    option routers 10.88.2.193;
    option broadcast-address 10.88.2.199;
}

# A3 - Durin (50 host)
subnet 10.88.2.128 netmask 255.255.255.192 {
    range 10.88.2.130 10.88.2.190;
    option routers 10.88.2.129;
    option broadcast-address 10.88.2.191;
}

# A2 - Gilgalad + Cirdan (120 host)
subnet 10.88.2.0 netmask 255.255.255.128 {
    range 10.88.2.2 10.88.2.126;
    option routers 10.88.2.1;
    option broadcast-address 10.88.2.127;
}

# A1 - Elendil + Isildur (230 host)
subnet 10.88.0.0 netmask 255.255.255.0 {
    range 10.88.0.2 10.88.0.254;
    option routers 10.88.0.1;
    option broadcast-address 10.88.0.255;
}

# Subnet Vilya sendiri
subnet 10.88.2.200 netmask 255.255.255.248 {
}
EOF

service isc-dhcp-server restart
echo "DHCP Server ready!"

# Testing: service isc-dhcp-server status
