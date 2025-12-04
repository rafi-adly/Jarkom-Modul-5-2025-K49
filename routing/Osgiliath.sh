#!/bin/bash

echo "[+] Setting static routes for Osgiliath..."

ip route add 10.88.0.0/24 via 10.88.2.218
ip route add 10.88.2.0/25 via 10.88.2.218
ip route add 10.88.2.240/30 via 10.88.2.218
ip route add 10.88.2.244/30 via 10.88.2.218
ip route add 10.88.2.248/30 via 10.88.2.218
ip route add 10.88.2.236/30 via 10.88.2.218

ip route add 10.88.2.128/26 via 10.88.2.210
ip route add 10.88.2.192/29 via 10.88.2.210
ip route add 10.88.2.220/30 via 10.88.2.210
ip route add 10.88.2.224/30 via 10.88.2.210

ip route add 10.88.2.200/29 via 10.88.2.214

echo "[✓] Routing Osgiliath COMPLETE!"
