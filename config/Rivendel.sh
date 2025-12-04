auto eth1
iface eth1 inet static
    address 10.88.2.214
    netmask 255.255.255.252
    gateway 10.88.2.213

auto eth0
iface eth0 inet static
    address 10.88.2.201
    netmask 255.255.255.248

# Routing
up route add -net 0.0.0.0/0 gw 10.88.2.213
