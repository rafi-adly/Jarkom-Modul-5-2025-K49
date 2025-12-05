auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.88.2.226
    netmask 255.255.255.252
    gateway 10.88.2.225

up echo "nameserver 10.88.2.203" > /etc/resolv.conf
