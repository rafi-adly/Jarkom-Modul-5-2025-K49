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
