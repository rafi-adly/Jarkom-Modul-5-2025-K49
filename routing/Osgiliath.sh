#!/bin/bash
echo "[+] Configuring Osgiliath routing..."

# Via Minastir (eth3: .217 → .218)
ip route add 10.88.0.0/24 via 10.88.2.218        # Elendil+Isildur
ip route add 10.88.2.0/25 via 10.88.2.218        # Gilgalad+Cirdan
ip route add 10.88.2.240/30 via 10.88.2.218      # Minastir-Pelargir link
ip route add 10.88.2.244/30 via 10.88.2.218      # Palantir
ip route add 10.88.2.248/30 via 10.88.2.218      # AnduinBanks link

# Via Moria (eth2: .209 → .210)
ip route add 10.88.2.128/26 via 10.88.2.210      # Durin
ip route add 10.88.2.192/29 via 10.88.2.210      # Khamul
ip route add 10.88.2.220/30 via 10.88.2.210      # Moria-Wilderland link
ip route add 10.88.2.224/30 via 10.88.2.210      # IronHills

# Via Rivendell (eth1: .213 → .214)
ip route add 10.88.2.200/29 via 10.88.2.214     

echo "[✓] Osgiliath routing complete!"
