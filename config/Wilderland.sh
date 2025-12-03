
auto eth0
iface eth0 inet static
    address 10.88.2.229
    netmask 255.255.255.252

auto eth1
iface eth1 inet static
    address 10.88.2.129
    netmask 255.255.255.192

auto eth2
iface eth2 inet static
    address 10.88.2.222
    netmask 255.255.255.252

# Routing
up route add -net 0.0.0.0/0 gw 10.88.2.221
up route add -net 10.88.2.192/29 gw 10.88.2.230
