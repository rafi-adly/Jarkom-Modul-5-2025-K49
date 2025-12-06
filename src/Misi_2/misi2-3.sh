# di Narya
#!/bin/bash

iptables -A INPUT -p tcp --dport 53 -s 10.88.2.202 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -s 10.88.2.202 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j REJECT
iptables -A INPUT -p udp --dport 53 -j REJECT

echo "DNS restricted to Vilya only!"

# Testing:
# apt update && apt install netcat-openbsd -y
# - Dari Vilya: nc -zvu 10.88.2.203 53 (SUCCESS)
# - Dari client: nc -zvu 10.88.2.203 53 (FAIL)

# ⚠️ HAPUS setelah testing: iptables -F
