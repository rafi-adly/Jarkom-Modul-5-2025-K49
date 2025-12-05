#!/bin/bash
echo "═══════════════════════════════════════════════════════════"
echo "RIVENDELL - Network Setup"
echo "═══════════════════════════════════════════════════════════"

# Bring up interfaces
ip link set eth0 up
ip link set eth1 up

# Configure IPs
ip addr add 10.88.2.214/30 dev eth0 2>/dev/null || true  # ke Osgiliath
ip addr add 10.88.2.201/29 dev eth1 2>/dev/null || true  # ke Switch1 (Vilya+Narya)

# Default route
ip route del default 2>/dev/null
ip route add default via 10.88.2.213 dev eth0 2>/dev/null || true

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl -w net.ipv4.ip_forward=1 > /dev/null

# Set DNS
echo "nameserver 192.168.122.1" > /etc/resolv.conf

echo ""
echo "Configuration:"
ip -4 addr show | grep "inet " | grep -v "127.0.0.1"
echo ""
echo "Routing:"
route -n
echo ""
echo "Testing connectivity..."
ping -c 2 10.88.2.213 > /dev/null && echo "✓ Osgiliath OK" || echo "✗ Osgiliath FAIL"
ping -c 2 8.8.8.8 > /dev/null && echo "✓ Internet OK" || echo "✗ Internet FAIL"
echo ""
echo "✓ Rivendell setup complete!"
