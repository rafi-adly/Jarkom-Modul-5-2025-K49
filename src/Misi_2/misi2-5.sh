#!/bin/bash

# Elf: 07:00-15:00 (Gilgalad+Cirdan)
iptables -A INPUT -p tcp --dport 80 -s 10.88.2.0/25 -m time --timestart 07:00 --timestop 15:00 -j ACCEPT

# Manusia: 17:00-23:00 (Elendil+Isildur)
iptables -A INPUT -p tcp --dport 80 -s 10.88.0.0/24 -m time --timestart 17:00 --timestop 23:00 -j ACCEPT

iptables -A INPUT -p tcp --dport 80 -j REJECT

echo "Palantir time-based access configured!"
