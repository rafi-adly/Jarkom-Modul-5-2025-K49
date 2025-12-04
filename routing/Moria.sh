route add -net 10.88.2.128/26 gw 10.88.2.222
route add -net 10.88.2.192/29 gw 10.88.2.222

echo "nameserver 192.168.122.1" > /etc/resolv.conf
