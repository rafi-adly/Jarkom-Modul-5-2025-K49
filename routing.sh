# Jalankan di Osgiliath
route add -net 10.88.0.0/24 gw 10.88.2.218      # Elendil+Isildur via Minastir
route add -net 10.88.2.0/25 gw 10.88.2.218      # Gilgalad+Cirdan via Minastir->Pelargir->AnduinBanks
route add -net 10.88.2.128/26 gw 10.88.2.210    # Durin via Moria->Wilderland
route add -net 10.88.2.192/29 gw 10.88.2.210    # Khamul via Moria->Wilderland
route add -net 10.88.2.200/29 gw 10.88.2.214    # Vilya+Narya via Rivendell
route add -net 10.88.2.224/30 gw 10.88.2.210    # IronHills via Moria
route add -net 10.88.2.244/30 gw 10.88.2.218    # Palantir via Minastir->Pelargir

# Route antar router
route add -net 10.88.2.220/30 gw 10.88.2.210    # Moria-Wilderland
route add -net 10.88.2.240/30 gw 10.88.2.218    # Minastir-Pelargir
route add -net 10.88.2.248/30 gw 10.88.2.218    # Pelargir-AnduinBanks
route add -net 10.88.2.252/30 gw 10.88.2.218    # AnduinBanks-Switch5
route add -net 10.88.2.232/30 gw 10.88.2.214    # Rivendell-Switch3

echo "Routing configured!"
