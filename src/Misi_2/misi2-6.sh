#!/bin/bash

iptables -N PORTSCAN
iptables -A INPUT -p tcp --dport 1:100 -m state --state NEW -m recent --set --name portscan
iptables -A INPUT -p tcp --dport 1:100 -m state --state NEW -m recent --update --seconds 20 --hitcount 15 --name portscan -j PORTSCAN
iptables -A PORTSCAN -j LOG --log-prefix "PORT_SCAN_DETECTED: " --log-level 4
iptables -A PORTSCAN -j REJECT
iptables -A INPUT -m recent --name portscan --rcheck -j REJECT

echo "Port scan detection active!"

# Testing: nmap -p 1-100 10.88.2.246
# Check log: dmesg | grep PORT_SCAN
