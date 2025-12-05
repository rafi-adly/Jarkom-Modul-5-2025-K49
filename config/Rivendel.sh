auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.88.2.201
    netmask 255.255.255.248
    gateway 10.88.2.213

auto eth1
iface eth1 inet static
    address 10.88.2.214
    netmask 255.255.255.252
