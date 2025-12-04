# Default
route add default gw 10.88.2.217

# A1
route add -net 10.88.0.0/24 gw 10.88.2.241

# A2
route add -net 10.88.2.0/25 gw 10.88.2.242

# Pelargir subnets
route add -net 10.88.2.244/30 gw 10.88.2.242
route add -net 10.88.2.248/30 gw 10.88.2.242
route add -net 10.88.2.252/30 gw 10.88.2.242

echo "nameserver 192.168.122.1" > /etc/resolv.conf
