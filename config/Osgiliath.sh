auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 10.88.2.213
    netmask 255.255.255.252

auto eth2
iface eth2 inet static
    address 10.88.2.209
    netmask 255.255.255.252

auto eth3
iface eth3 inet static
    address 10.88.2.217
    netmask 255.255.255.252

# Routing
up ip route add 10.88.0.0/24 via 10.88.2.218
up ip route add 10.88.2.0/25 via 10.88.2.218
up ip route add 10.88.2.240/30 via 10.88.2.218
up ip route add 10.88.2.244/30 via 10.88.2.218
up ip route add 10.88.2.248/30 via 10.88.2.218
up ip route add 10.88.2.128/26 via 10.88.2.210
up ip route add 10.88.2.192/29 via 10.88.2.210
up ip route add 10.88.2.220/30 via 10.88.2.210
up ip route add 10.88.2.224/30 via 10.88.2.210
up ip route add 10.88.2.200/29 via 10.88.2.213
