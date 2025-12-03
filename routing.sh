#!/bin/bash

# Route ke client subnets
route add -net 10.88.0.0/24 gw 10.88.2.218      # Elendil+Isildur via Minastir
route add -net 10.88.2.0/25 gw 10.88.2.218      # Gilgalad+Cirdan via Minastir
route add -net 10.88.2.128/26 gw 10.88.2.210    # Durin via Moria
route add -net 10.88.2.192/29 gw 10.88.2.210    # Khamul via Moria

# Route ke servers
route add -net 10.88.2.200/29 gw 10.88.2.214    # Vilya+Narya via Rivendell
route add -net 10.88.2.224/30 gw 10.88.2.210    # IronHills via Moria
route add -net 10.88.2.244/30 gw 10.88.2.218    # Palantir via Minastir

echo "Routing configured!"
