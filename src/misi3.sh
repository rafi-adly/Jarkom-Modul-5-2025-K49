#!/bin/bash

# Allow Durin DULU (prioritas tinggi)
iptables -I FORWARD 1 -s 10.88.2.128/26 -j ACCEPT
iptables -I FORWARD 1 -d 10.88.2.128/26 -j ACCEPT

# Blokir Khamul (5 host - 10.88.2.192/29)
iptables -A INPUT -s 10.88.2.192/29 -j DROP
iptables -A OUTPUT -d 10.88.2.192/29 -j DROP
iptables -A FORWARD -s 10.88.2.192/29 -j DROP
iptables -A FORWARD -d 10.88.2.192/29 -j DROP

echo "Khamul ISOLATED!"

# Testing:
# - Dari Khamul: ping google.com (FAIL)
# - Dari Durin: ping google.com (SUCCESS!)
