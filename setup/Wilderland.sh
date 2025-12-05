echo "═══════════════════════════════════════════════════════════"
echo "WILDERLAND - Network Setup"
echo "═══════════════════════════════════════════════════════════"

# Bring up interfaces
ip link set eth0 up
ip link set eth1 up
ip link set eth2 up

# Configure IPs
ip addr add 10.88.2.222/30 dev eth0 2>/dev/null || true  # ke Moria
ip addr add 10.88.2.129/26 dev eth1 2>/dev/null || true  # ke Durin
ip addr add 10.88.2.193/29 dev eth2 2>/dev/null || true  # ke Switch3 (Khamul)

# Default route
ip route del default 2>/dev/null
ip route add default via 10.88.2.221 dev eth0 2>/dev/null || true

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
ping -c 2 10.88.2.221 > /dev/null && echo "✓ Moria OK" || echo "✗ Moria FAIL"
ping -c 2 8.8.8.8 > /dev/null && echo "✓ Internet OK" || echo "✗ Internet FAIL"
echo ""
echo "✓ Wilderland setup complete!"
