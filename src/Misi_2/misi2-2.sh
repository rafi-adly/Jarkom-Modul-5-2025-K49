
#!/bin/bash

iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
iptables -A OUTPUT -p icmp -j ACCEPT

echo "Vilya protected from ping!"

# Testing:
# - Dari client: ping 10.88.2.202 (FAIL)
# - Dari Vilya: ping google.com (SUCCESS)
