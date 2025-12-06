#!/bin/bash

iptables -t nat -A OUTPUT -d 10.88.2.192/29 -j DNAT --to-destination 10.88.2.226

echo "Traffic redirected: Khamul → IronHills"

# Testing: nc 10.88.2.194 80 (dari Vilya, akan ke IronHills)
