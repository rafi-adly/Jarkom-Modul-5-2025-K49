#!/bin/bash

# === Reset iptables ===
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD
iptables -X

iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

# === Loopback ===
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# === Terima traffic ESTABLISHED/RELATED ===
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# === Allow Durin dulu ===
iptables -A FORWARD -s 10.88.2.128/26 -j ACCEPT
iptables -A FORWARD -d 10.88.2.128/26 -j ACCEPT
iptables -A INPUT -s 10.88.2.128/26 -j ACCEPT
iptables -A OUTPUT -d 10.88.2.128/26 -j ACCEPT

# === DROP semua traffic Khamul (tidak pakai -I) ===
iptables -A INPUT -s 10.88.2.192/29 -j DROP
iptables -A OUTPUT -d 10.88.2.192/29 -j DROP
iptables -A FORWARD -s 10.88.2.192/29 -j DROP
iptables -A FORWARD -d 10.88.2.192/29 -j DROP

echo "=== Khamul ISOLATED ==="
