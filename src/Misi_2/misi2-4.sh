
#!/bin/bash

# Set waktu ke Rabu untuk testing
date -s "2025-11-26 12:00:00"

# Durin & Khamul (Kurcaci)
iptables -A INPUT -p tcp --dport 80 -s 10.88.2.128/26 -m time --weekdays Sa,Su -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -s 10.88.2.192/29 -m time --weekdays Sa,Su -j ACCEPT

# Elendil & Isildur (Manusia)
iptables -A INPUT -p tcp --dport 80 -s 10.88.0.0/24 -m time --weekdays Sa,Su -j ACCEPT

iptables -A INPUT -p tcp --dport 80 -j DROP

echo "IronHills weekend-only configured!"

# Testing di Client
# - Rabu: curl http://10.88.2.226 (FAIL)
# - Ubah ke Sabtu: date -s "2025-11-29 12:00:00"
# - Sabtu: curl http://10.88.2.226 (SUCCESS)
