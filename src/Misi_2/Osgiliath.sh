#!/bin/bash

echo "[+] Enabling IP forwarding..."
echo 1 > /proc/sys/net/ipv4/ip_forward

echo "[+] Checking eth0 IP..."
ETH0_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)

# Jika DHCP gagal → fallback IP
if [ -z "$ETH0_IP" ]; then
    echo "[!] DHCP failed! Setting fallback IP 192.168.122.100/24"
    ip addr add 192.168.122.100/24 dev eth0 2>/dev/null || true
    ETH0_IP="192.168.122.100"
fi

echo "[+] eth0 IP detected: $ETH0_IP"

echo "[+] Setting default route to 192.168.122.1..."
ip route del default 2>/dev/null
ip route add default via 192.168.122.1 dev eth0 2>/dev/null || true

echo "[+] Updating DNS..."
cat > /etc/resolv.conf << EOF
nameserver 8.8.8.8
nameserver 1.1.1.1
EOF

echo "[+] Configuring NAT & FORWARD rules..."

# bersihkan semua iptables
iptables -F
iptables -t nat -F
iptables -X

# policy default
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# allow return traffic
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
# allow seluruh subnet 10.88.x.x keluar lewat Osgiliath
iptables -A FORWARD -s 10.88.0.0/16 -j ACCEPT

# NAT: subnet internal → internet melalui eth0
iptables -t nat -A POSTROUTING -s 10.88.0.0/16 -o eth0 -j SNAT --to-source $ETH0_IP

echo
echo "[✔] Osgiliath networking configured!"
echo "    - eth0 : $ETH0_IP"
echo "    - gateway : 192.168.122.1"
echo "    - DNS : 8.8.8.8 | 1.1.1.1"
echo "    - NAT enabled for 10.88.0.0/16"
echo "[✔] Semua server harusnya sudah bisa ping 8.8.8.8"
