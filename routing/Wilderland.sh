# Default route ke Moria
route add -net 0.0.0.0/0 gw 10.88.2.221

# Client/server networks via Moria
route add -net 10.88.0.0/24 gw 10.88.2.210
route add -net 10.88.2.0/25 gw 10.88.2.210
route add -net 10.88.2.200/29 gw 10.88.2.210
route add -net 10.88.2.224/30 gw 10.88.2.210
route add -net 10.88.2.244/30 gw 10.88.2.210
