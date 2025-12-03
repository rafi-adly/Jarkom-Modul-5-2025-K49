#!/bin/bash

echo "[OSGILIATH] Configuring networking..."

# 1. IP Forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# 2. Ambil IP eth0 dari DHCP
ETH0_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)

if [ -z "$ETH0_IP" ]; then
    echo "[!] DHCP failed! Setting fallback IP"
    ip addr add 192.168.122.100/24 dev eth0 2>/dev/null || true
    ETH0_IP="192.168.122.100"
fi

echo "[+] eth0 IP: $ETH0_IP"

# 3. Default route ke internet (NAT Cloud)
ip route del default 2>/dev/null
ip route add default via 192.168.122.1 dev eth0

# 4. DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# 5. NAT (SNAT, BUKAN MASQUERADE!)
iptables -t nat -F POSTROUTING
iptables -t nat -A POSTROUTING -s 10.88.0.0/16 -o eth0 -j SNAT --to-source $ETH0_IP

# 6. ROUTING ke semua subnet
# Via Minastir (eth1: 10.88.2.217)
ip route add 10.88.0.0/24 via 10.88.2.218  
ip route add 10.88.2.0/25 via 10.88.2.218  
ip route add 10.88.2.240/30 via 10.88.2.218  
ip route add 10.88.2.244/30 via 10.88.2.218  
ip route add 10.88.2.248/30 via 10.88.2.218 

# Via Moria (eth2: 10.88.2.209)
ip route add 10.88.2.128/26 via 10.88.2.210 
ip route add 10.88.2.192/29 via 10.88.2.210 
ip route add 10.88.2.220/30 via 10.88.2.210 
ip route add 10.88.2.224/30 via 10.88.2.210    

# Via Rivendell (eth3: 10.88.2.213)
ip route add 10.88.2.200/29 via 10.88.2.214    

echo "[✓] Osgiliath routing configured!"
echo ""
echo "Testing connectivity..."
ping 8.8.8.8 -c 2
