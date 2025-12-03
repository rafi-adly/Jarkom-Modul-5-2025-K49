#!/bin/bash

echo "[MORIA] Configuring networking..."

# IP Forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Default route ke Osgiliath
ip route add default via 10.88.2.209 dev eth0

# Route ke Durin via Wilderland
ip route add 10.88.2.128/26 via 10.88.2.222 dev eth1

# Route ke Khamul via Wilderland
ip route add 10.88.2.192/29 via 10.88.2.222 dev eth1

echo "[✓] Moria routing configured!"
