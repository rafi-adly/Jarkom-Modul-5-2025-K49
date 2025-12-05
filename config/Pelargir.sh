auto eth0
iface eth0 inet static
    address 10.88.2.242  
    netmask 255.255.255.252
    gateway 10.88.2.241

auto eth1
iface eth1 inet static
    address 10.88.2.249   
    netmask 255.255.255.252

auto eth2
iface eth2 inet static
    address 10.88.2.245   
    netmask 255.255.255.252

# Routing
up route add -net 10.88.2.0/25 gw 10.88.2.250
