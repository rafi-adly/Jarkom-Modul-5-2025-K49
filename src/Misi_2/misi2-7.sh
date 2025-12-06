#!/bin/bash

date -s "2025-11-29 12:00:00"  # Sabtu
iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above 3 --connlimit-mask 32 -j REJECT --reject-with tcp-reset

echo "Connection limit: 3 per IP"

# Testing: for i in {1..5}; do curl http://10.88.2.226 & done
