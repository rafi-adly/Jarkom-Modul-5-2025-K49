auto eth0
iface eth0 inet static
    address 10.88.2.194
    netmask 255.255.255.248   # /29
    gateway 10.88.2.193
    dns-nameservers 10.88.2.203
