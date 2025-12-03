# Default route ke Osgiliath
route add -net 0.0.0.0/0 gw 10.88.2.209

# Client/Server networks
route add -net 10.88.0.0/24 gw 10.88.2.209
route add -net 10.88.2.0/25 gw 10.88.2.209
route add -net 10.88.2.200/29 gw 10.88.2.209
route add -net 10.88.2.244/30 gw 10.88.2.209
