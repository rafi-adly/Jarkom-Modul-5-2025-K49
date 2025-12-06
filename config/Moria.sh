auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.88.2.210
    netmask 255.255.255.252
    gateway 10.88.2.209

auto eth1
iface eth1 inet static
    address 10.88.2.225
    netmask 255.255.255.252

auto eth2
iface eth2 inet static
    address 10.88.2.221
    netmask 255.255.255.252

# Routing
up ip route add 10.88.2.192/29 via 10.88.2.222
up ip route add 10.88.2.128/26 via 10.88.2.222
