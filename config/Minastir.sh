auto eth0
iface eth0 inet static
    address 10.88.2.237
    netmask 255.255.255.252

auto eth1
iface eth1 inet static
    address 10.88.2.241
    netmask 255.255.255.252

auto eth2
iface eth2 inet static
    address 10.88.2.218
    netmask 255.255.255.252

# Routing
up route add -net 0.0.0.0/0 gw 10.88.2.217
up route add -net 10.88.0.0/24 gw 10.88.2.238
up route add -net 10.88.2.0/25 gw 10.88.2.242
up route add -net 10.88.2.244/30 gw 10.88.2.242
up route add -net 10.88.2.248/30 gw 10.88.2.242
up route add -net 10.88.2.252/30 gw 10.88.2.242
