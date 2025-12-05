auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.88.2.203
    netmask 255.255.255.248
    gateway 10.88.2.201

up echo "nameserver 192.168.122.1" > /etc/resolv.conf
