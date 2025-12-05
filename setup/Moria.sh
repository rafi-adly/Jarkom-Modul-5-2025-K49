echo "═══════════════════════════════════════════════════════════"
echo "MORIA - Network Setup"
echo "═══════════════════════════════════════════════════════════"

# Bring up interfaces
ip link set eth0 up
ip link set eth1 up
ip link set eth2 up

# Configure IPs
ip addr add 10.88.2.210/30 dev eth0 2>/dev/null || true  # ke Osgiliath
ip addr add 10.88.2.225/30 dev eth1 2>/dev/null || true  # ke Switch2 (IronHills)
ip addr add 10.88.2.221/30 dev eth2 2>/dev/null || true  # ke Wilderland

# Default route
ip route del default 2>/dev/null
ip route add default via 10.88.2.209 dev eth0 2>/dev/null || true

# Route to Khamul via Wilderland
ip route add 10.88.2.192/29 via 10.88.2.222 2>/dev/null || true

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
ping -c 2 10.88.2.209 > /dev/null && echo "✓ Osgiliath OK" || echo "✗ Osgiliath FAIL"
ping -c 2 8.8.8.8 > /dev/null && echo "✓ Internet OK" || echo "✗ Internet FAIL"
echo ""
echo "✓ Moria setup complete!"
