#!/bin/bash
# /root/setup_osgiliath.sh
# Complete Osgiliath configuration script

echo "═══════════════════════════════════════════════════════════"
echo "OSGILIATH - Complete Network Setup"
echo "═══════════════════════════════════════════════════════════"

# 1. Bring up all interfaces
echo "[1] Bringing up interfaces..."
ip link set eth0 up
ip link set eth1 up
ip link set eth2 up
ip link set eth3 up

# 2. Apply static IPs for internal interfaces
echo "[2] Configuring internal interfaces..."
ip addr add 10.88.2.213/30 dev eth1 2>/dev/null || true  # ke Rivendell
ip addr add 10.88.2.209/30 dev eth2 2>/dev/null || true  # ke Moria
ip addr add 10.88.2.217/30 dev eth3 2>/dev/null || true  # ke Minastir

# 3. Start DHCP for eth0 (NAT interface)
echo "[3] Starting DHCP on eth0..."
udhcpc -i eth0 -n -q 2>/dev/null &
sleep 5

# 4. Check eth0 IP
ETH0_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
if [ -z "$ETH0_IP" ]; then
    echo "    Warning: DHCP failed, using static IP"
    ip addr add 192.168.122.100/24 dev eth0 2>/dev/null || true
    ETH0_IP="192.168.122.100"
fi

# 5. Ensure default route exists
echo "[4] Setting default route..."
ip route del default 2>/dev/null
ip route add default via 192.168.122.1 dev eth0 2>/dev/null || true

echo ""
echo "Interface configuration:"
echo "  eth0 (NAT): $ETH0_IP"
echo "  eth1 (Rivendell):"
ip -4 addr show eth1 | grep inet | awk '{print "    " $2}'
echo "  eth2 (Moria):"
ip -4 addr show eth2 | grep inet | awk '{print "    " $2}'
echo "  eth3 (Minastir):"
ip -4 addr show eth3 | grep inet | awk '{print "    " $2}'
echo ""

# 6. Test internet connectivity
echo "[5] Testing internet..."
if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
    echo "    ✓ Internet OK"
else
    echo "    ✗ Internet FAILED"
fi
echo ""

# 7. Enable IP forwarding
echo "[6] Enabling IP forwarding..."
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl -w net.ipv4.ip_forward=1 > /dev/null

# 8. Set DNS
echo "[7] Configuring DNS..."
cat > /etc/resolv.conf << 'EOF'
nameserver 192.168.122.1
nameserver 8.8.8.8
EOF

# 9. Setup iptables NAT
echo "[8] Configuring NAT..."
iptables -F
iptables -t nat -F
iptables -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# SNAT rule (NO MASQUERADE as per requirement)
iptables -t nat -A POSTROUTING -s 10.88.0.0/16 -o eth0 -j SNAT --to-source $ETH0_IP

# Allow forwarding
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -s 10.88.0.0/16 -j ACCEPT

echo "    ✓ NAT configured"

# 10. Setup static routing
echo "[9] Configuring static routes..."

# Via Minastir (eth3: .217 → .218)
ip route add 10.88.0.0/24 via 10.88.2.218 2>/dev/null || true       # Elendil+Isildur
ip route add 10.88.2.0/25 via 10.88.2.218 2>/dev/null || true       # Gilgalad+Cirdan
ip route add 10.88.2.240/30 via 10.88.2.218 2>/dev/null || true     # Minastir-Pelargir
ip route add 10.88.2.244/30 via 10.88.2.218 2>/dev/null || true     # Palantir
ip route add 10.88.2.248/30 via 10.88.2.218 2>/dev/null || true     # AnduinBanks

# Via Moria (eth2: .209 → .210)
ip route add 10.88.2.128/26 via 10.88.2.210 2>/dev/null || true     # Durin
ip route add 10.88.2.192/29 via 10.88.2.210 2>/dev/null || true     # Khamul
ip route add 10.88.2.220/30 via 10.88.2.210 2>/dev/null || true     # Moria-Wilderland
ip route add 10.88.2.224/30 via 10.88.2.210 2>/dev/null || true     # IronHills

# Via Rivendell (eth1: .213 → .214)
ip route add 10.88.2.200/29 via 10.88.2.214 2>/dev/null || true     # Vilya+Narya

echo "    ✓ Routes configured"
echo ""

# 11. Display final configuration
echo "═══════════════════════════════════════════════════════════"
echo "FINAL CONFIGURATION"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "Routing Table:"
route -n
echo ""
echo "NAT Configuration:"
iptables -t nat -L -n -v | grep -A 5 "Chain POSTROUTING"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "✓ Osgiliath setup complete!"
echo "═══════════════════════════════════════════════════════════"
