#!/bin/bash

echo "[+] Installing rsyslog for iptables logging..."
apt-get update
apt-get install -y rsyslog

# Enable kernel logging to dmesg + /var/log/kern.log
echo "[+] Configuring rsyslog..."
cat > /etc/rsyslog.d/10-iptables.conf << 'EOF'
kern.*    /var/log/kern.log
kern.*    /dev/kmsg
EOF

service rsyslog restart

echo "[+] Setting up iptables port-scan detection..."

# Firewall rules (punya kamu)
iptables -N PORTSCAN 2>/dev/null || iptables -F PORTSCAN

iptables -A INPUT -p tcp --dport 1:100 -m state --state NEW -m recent --set --name portscan
iptables -A INPUT -p tcp --dport 1:100 -m state --state NEW -m recent --update --seconds 20 --hitcount 15 --name portscan -j PORTSCAN

iptables -A PORTSCAN -j LOG --log-prefix "PORT_SCAN_DETECTED: " --log-level 4
iptables -A PORTSCAN -j REJECT

iptables -A INPUT -m recent --name portscan --rcheck -j REJECT

echo "Port scan detection active!"
echo "Check logs using: dmesg | grep PORT_SCAN or cat /var/log/kern.log | grep PORT_SCAN"
