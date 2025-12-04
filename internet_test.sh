#!/bin/bash
# di setiap router untuk test & fix koneksi internet

# ═══════════════════════════════════════════════════════════════
# ROUTER - Internet Connectivity Test & Auto-Fix
# ═══════════════════════════════════════════════════════════════

echo "═══════════════════════════════════════════════════════════"
echo "Testing Internet Connectivity on $(hostname)"
echo "═══════════════════════════════════════════════════════════"
echo ""

# 1. Check default route
echo "[1] Checking default route..."
DEFAULT_GW=$(ip route | grep default | awk '{print $3}')

if [ -z "$DEFAULT_GW" ]; then
    echo "    ✗ No default route found!"
    echo ""
    echo "    Available gateways:"
    ip route | grep "^10.88" | awk '{print "      - "$1" via "$3}'
    echo ""
    echo "    Please add default route manually:"
    echo "    ip route add default via <gateway_ip>"
else
    echo "    ✓ Default gateway: $DEFAULT_GW"
fi

echo ""

# 2. Test ping to gateway
echo "[2] Testing ping to gateway ($DEFAULT_GW)..."
if ping -c 2 -W 2 $DEFAULT_GW > /dev/null 2>&1; then
    echo "    ✓ Gateway reachable"
else
    echo "    ✗ Gateway NOT reachable!"
    echo "    Check interface configuration and cables in GNS3"
fi

echo ""

# 3. Test ping to Osgiliath
echo "[3] Testing ping to Osgiliath (checking routing)..."
OSGILIATH_IPS="10.88.2.209 10.88.2.213 10.88.2.217"
OSG_OK=false

for ip in $OSGILIATH_IPS; do
    if ping -c 2 -W 2 $ip > /dev/null 2>&1; then
        echo "    ✓ Osgiliath reachable at $ip"
        OSG_OK=true
        break
    fi
done

if [ "$OSG_OK" = false ]; then
    echo "    ✗ Cannot reach Osgiliath!"
    echo "    Check routing configuration"
fi

echo ""

# 4. Test ping to internet
echo "[4] Testing ping to 8.8.8.8 (Google DNS)..."
if ping -c 2 -W 3 8.8.8.8 > /dev/null 2>&1; then
    echo "    ✓ Internet reachable!"
else
    echo "    ✗ Internet NOT reachable!"
    echo "    NAT might not be configured on Osgiliath"
fi

echo ""

# 5. Test DNS resolution
echo "[5] Testing DNS resolution..."
if nslookup google.com > /dev/null 2>&1; then
    echo "    ✓ DNS working!"
else
    echo "    ✗ DNS not working"
    echo "    Current DNS: $(cat /etc/resolv.conf | grep nameserver)"
fi

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "Summary:"
echo "═══════════════════════════════════════════════════════════"
route -n
echo ""
cat /etc/resolv.conf
