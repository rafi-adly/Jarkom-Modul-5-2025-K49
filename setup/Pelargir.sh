#!/bin/bash
echo "═══════════════════════════════════════════════════════════"
echo "PELARGIR - Network Setup"
echo "═══════════════════════════════════════════════════════════"

# Bring up interfaces
ip link set eth0 up
ip link set eth1 up
ip link set eth2 up

# Configure IPs
ip addr add 10.88.2.242/30 dev eth0 2>/dev/null || true  # ke Minastir
ip addr add 10.88.2.249/30 dev eth1 2>/dev/null || true  # ke AnduinBanks
ip addr add 10.88.2.245/30 dev eth2 2>/dev/null || true  # ke Palantir

# Default route
ip route del default 2>/dev/null
ip route add default via 10.88.2.241 dev eth0 2>/dev/null || true

# Route via AnduinBanks
ip route add 10.88.2.0/25 via 10.88.2.250 2>/dev/null || true      # Gilgalad+Cirdan

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
ping -c 2 10.88.2.241 > /dev/null && echo "✓ Minastir OK" || echo "✗ Minastir FAIL"
ping -c 2 8.8.8.8 > /dev/null && echo "✓ Internet OK" || echo "✗ Internet FAIL"
echo ""
echo "✓ Pelargir setup complete!"
