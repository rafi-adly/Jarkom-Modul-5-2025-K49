#!/bin/bash
echo "═══════════════════════════════════════════════════════════"
echo "RIVENDELL - Network Setup"
echo "═══════════════════════════════════════════════════════════"

# Kill any DHCP client that might interfere
killall udhcpc dhclient 2>/dev/null

# Bring down interfaces first
ip link set eth0 down
ip link set eth1 down

# Flush everything
ip addr flush dev eth0
ip addr flush dev eth1
ip route flush dev eth0 2>/dev/null
ip route flush dev eth1 2>/dev/null

# Bring up interfaces
ip link set eth0 up
ip link set eth1 up

# Wait for interfaces
sleep 2

# Configure IPs
ip addr add 10.88.2.214/30 dev eth0
ip addr add 10.88.2.201/29 dev eth1

# Wait for IP to settle
sleep 1

# Check if gateway is reachable
echo "[+] Testing gateway before adding route..."
ping -c 1 -W 2 10.88.2.213 > /dev/null
if [ $? -eq 0 ]; then
    echo "    ✓ Gateway reachable"
else
    echo "    ✗ Gateway NOT reachable - check cable!"
fi

# Add default route
route add default gw 10.88.2.213 dev eth0

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Set DNS
echo "nameserver 192.168.122.1" > /etc/resolv.conf

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "Configuration:"
echo "═══════════════════════════════════════════════════════════"
ip -4 addr show | grep "inet " | grep -v "127.0.0.1"
echo ""
echo "Routing:"
route -n
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "Connectivity Tests:"
echo "═══════════════════════════════════════════════════════════"
ping -c 2 10.88.2.213 > /dev/null && echo "✓ Osgiliath (10.88.2.213) OK" || echo "✗ Osgiliath FAIL"
ping -c 2 8.8.8.8 > /dev/null && echo "✓ Internet (8.8.8.8) OK" || echo "✗ Internet FAIL"
ping -c 2 10.88.2.202 > /dev/null && echo "✓ Vilya (10.88.2.202) OK" || echo "✗ Vilya FAIL"
echo ""
echo "✓ Rivendell setup complete!"
