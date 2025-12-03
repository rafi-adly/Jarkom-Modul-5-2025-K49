
auto eth0
iface eth0 inet static
    address 10.88.2.253
    netmask 255.255.255.252

auto eth1
iface eth1 inet static
    address 10.88.2.250
    netmask 255.255.255.252

# Routing
up route add -net 0.0.0.0/0 gw 10.88.2.249
up route add -net 10.88.2.0/25 gw 10.88.2.254
