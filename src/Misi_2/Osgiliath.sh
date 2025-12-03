#!/bin/bash

echo "[+] Enabling IP forwarding..."
echo 1 > /proc/sys/net/ipv4/ip_forward

echo "[+] Checking eth0 IP..."
ETH0_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)

# Jika DHCP gagal → set fallback IP
if [ -z "$ETH0_IP" ]; then
    echo "[!] DHCP failed! Setting fallback IP 192.168.122.100/24"
    ip addr add 192.168.122.100/24 dev eth0 2>/dev/null || true
    ETH0_IP="192.168.122.100"
fi

echo "[+] eth0 IP detected: $ETH0_IP"

# Set default gateway ke virbr0 NAT bawaan GNS3 VM
echo "[+] Setting default route to 192.168.122.1..."
ip route del default 2>/dev/null
ip route add default via 192.168.122.1 dev eth0 2>/dev/null || true

# Set DNS
echo "[+] Updating DNS..."
echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo
echo "[✔] Osgiliath networking configured!"
echo "    - eth0 : $ETH0_IP"
echo "    - gateway : 192.168.122.1"
echo "    - DNS : 8.8.8.8"
echo "[✔] You should now be able to ping Google."
