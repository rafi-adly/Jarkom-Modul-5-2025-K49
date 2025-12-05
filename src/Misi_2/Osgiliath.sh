#!/bin/bash

echo "[+] Enabling IP forwarding..."
echo 1 > /proc/sys/net/ipv4/ip_forward

echo "[+] Getting eth0 IP address..."
ETH0_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)

if [ -z "$ETH0_IP" ]; then
    echo "[!] ERROR: eth0 has no IP address!"
    exit 1
fi

echo "[+] eth0 IP detected: $ETH0_IP"

# Flush NAT rules (clean slate)
echo "[+] Flushing old NAT rules..."
iptables -t nat -F
iptables -t nat -X

# Add SNAT rule (sesuai ketentuan soal: NO MASQUERADE!)
echo "[+] Adding SNAT rule..."
iptables -t nat -A POSTROUTING -s 10.88.0.0/16 -o eth0 -j SNAT --to-source $ETH0_IP

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "✓ NAT Configuration Complete!"
echo "═══════════════════════════════════════════════════════════"
echo "  Source Network : 10.88.0.0/16"
echo "  NAT IP         : $ETH0_IP"
echo "  Method         : SNAT (not MASQUERADE)"
echo ""
echo "NAT Table:"
iptables -t nat -L -n -v
echo ""
echo "Test from other routers: ping 8.8.8.8"

# Testing:
# ping google.com
