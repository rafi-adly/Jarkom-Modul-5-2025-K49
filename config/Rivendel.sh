auto eth0
iface eth0 inet static
    address 10.88.2.233
    netmask 255.255.255.252

auto eth1
iface eth1 inet static
    address 10.88.2.214
    netmask 255.255.255.252

# Routing
up route add -net 0.0.0.0/0 gw 10.88.2.213
