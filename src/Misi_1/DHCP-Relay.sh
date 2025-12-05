# ═══════════════════════════════════════════════════════════════
# MISI 1.4: DHCP RELAY - SPECIFIC FOR EACH ROUTER
# ═══════════════════════════════════════════════════════════════

# ┌─────────────────────────────────────────────────────────────┐
# │ WILDERLAND - DHCP Relay                                     │
# └─────────────────────────────────────────────────────────────┘
#!/bin/bash

apt-get update
apt-get install -y isc-dhcp-relay

cat > /etc/default/isc-dhcp-relay << 'EOF'
SERVERS="10.88.2.202"
INTERFACES="eth0 eth1"
OPTIONS=""
EOF

service isc-dhcp-relay restart
echo "DHCP Relay (Rivendell) ready!"

# ┌─────────────────────────────────────────────────────────────┐
# │ WILDERLAND - DHCP Relay                                     │
# └─────────────────────────────────────────────────────────────┘
#!/bin/bash

apt-get update
apt-get install -y isc-dhcp-relay

cat > /etc/default/isc-dhcp-relay << 'EOF'
SERVERS="10.88.2.202"
INTERFACES="eth0 eth1 eth2"
OPTIONS=""
EOF

service isc-dhcp-relay restart
echo "DHCP Relay (Wilderland) ready!"

# ┌─────────────────────────────────────────────────────────────┐
# │ MINASTIR - DHCP Relay                                       │
# └─────────────────────────────────────────────────────────────┘
#!/bin/bash

apt-get update
apt-get install -y isc-dhcp-relay

cat > /etc/default/isc-dhcp-relay << 'EOF'
SERVERS="10.88.2.202"
INTERFACES="eth0 eth1 eth2"
OPTIONS=""
EOF

service isc-dhcp-relay restart
echo "DHCP Relay (Minastir) ready!"

# ┌─────────────────────────────────────────────────────────────┐
# │ ANDUINBANKS - DHCP Relay                                    │
# └─────────────────────────────────────────────────────────────┘
#!/bin/bash

apt-get update
apt-get install -y isc-dhcp-relay

cat > /etc/default/isc-dhcp-relay << 'EOF'
SERVERS="10.88.2.202"
INTERFACES="eth0 eth1"
OPTIONS=""
EOF

service isc-dhcp-relay restart
echo "DHCP Relay (AnduinBanks) ready!"
