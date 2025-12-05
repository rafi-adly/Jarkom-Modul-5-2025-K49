echo "═══════════════════════════════════════════════════════════"
echo "MINASTIR - Network Setup"
echo "═══════════════════════════════════════════════════════════"

# Bring up interfaces
ip link set eth0 up
ip link set eth1 up
ip link set eth2 up

# Configure IPs
ip addr add 10.88.2.218/30 dev eth0 2>/dev/null || true  # ke Osgiliath
ip addr add 10.88.0.1/24 dev eth1 2>/dev/null || true    # ke Switch4 (Elendil+Isildur)
ip addr add 10.88.2.241/30 dev eth2 2>/dev/null || true  # ke Pelargir

# Default route
ip route del default 2>/dev/null
ip route add default via 10.88.2.217 dev eth0 2>/dev/null || true

# Routes via Pelargir
ip route add 10.88.2.0/25 via 10.88.2.242 2>/dev/null || true      # Gilgalad+Cirdan
ip route add 10.88.2.244/30 via 10.88.2.242 2>/dev/null || true    # Palantir
ip route add 10.88.2.248/30 via 10.88.2.242 2>/dev/null || true    # AnduinBanks

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
ping -c 2 10.88.2.217 > /dev/null && echo "✓ Osgiliath OK" || echo "✗ Osgiliath FAIL"
ping -c 2 8.8.8.8 > /dev/null && echo "✓ Internet OK" || echo "✗ Internet FAIL"
echo ""
echo "✓ Minastir setup complete!"
