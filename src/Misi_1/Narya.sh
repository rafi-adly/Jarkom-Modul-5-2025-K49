#!/bin/bash
# FILE: /root/dns.sh

apt-get update
apt-get install bind9 -y

cat > /etc/bind/named.conf.options << 'EOF'
options {
    directory "/var/cache/bind";
    forwarders {
        192.168.122.1
    };
    allow-query { any; };
    auth-nxdomain no;
    listen-on-v6 { any; };
};
EOF

service bind9 restart
named -c /etc/bind/named.conf -f &
echo "DNS Server ready!"

# Testing: nslookup google.com
