#!/bin/bash

echo "[+] Installing ulogd2 for NFLOG logging..."
apt-get update
apt-get install -y ulogd2

echo "[+] Starting ulogd2..."
ulogd -d &

echo "[+] Flushing old rules..."
iptables -F
iptables -X PORTSCAN 2>/dev/null
iptables -N PORTSCAN

echo "[+] Applying port-scan rules..."

# Accept established + localhost
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT

# Track new hits
iptables -A INPUT -p tcp --dport 1:100 -m recent --set --name portscan
iptables -A INPUT -p tcp --dport 1:100 -m recent --update --seconds 20 --hitcount 15 --name portscan -j PORTSCAN

# Log via NFLOG -> ulogd2
iptables -A PORTSCAN -j NFLOG --nflog-prefix "PORT_SCAN_DETECTED: "

# Drop attacker
iptables -A PORTSCAN -j DROP

# Persistent block
iptables -A INPUT -m recent --rcheck --name portscan -j DROP

echo "[+] Port scan detection is ACTIVE."
echo "[+] Check logs: tail -f /var/log/ulog/syslogemu.log | grep PORT_SCAN"
