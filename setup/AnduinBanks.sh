#!/bin/bash
echo "═══════════════════════════════════════════════════════════"
echo "ANDUINBANKS - Network Setup (FIXED)"
echo "═══════════════════════════════════════════════════════════"

# Kill DHCP client
killall udhcpc dhclient 2>/dev/null

# Bring down first
ip link set eth0 down
ip link set eth1 down

# Flush everything
ip addr flush dev eth0
ip addr flush dev eth1

# Bring up
ip link set eth0 up
ip link set eth1 up

# Wait
sleep 2

# Configure IPs (ini otomatis bikin directly connected routes!)
ip addr add 10.88.2.250/30 dev eth0
ip addr add 10.88.2.1/25 dev eth1

# Wait for routes to settle
sleep 1

# Show directly connected routes
echo "[+] Directly connected routes:"
ip route show | grep -E "10.88.2.248|10.88.2.0"

# Now add default route
echo "[+] Adding default route..."
ip route add default via 10.88.2.249 dev eth0

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

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
ping -c 2 10.88.2.249 && echo "✓ Pelargir OK" || echo "✗ Pelargir FAIL"
ping -c 2 8.8.8.8 && echo "✓ Internet OK" || echo "✗ Internet FAIL"
echo ""
echo "✓ AnduinBanks setup complete!"
