# Jarkom-Modul-5-2025-K49

| Nama                       | NRP        |
| -------------------------- | ---------- |
| Revalina Erica Permatasari | 5027241007 |
| Muhammad Rafi` Adly        | 5027241082 |

**Prefix IP:** `10.88.x.x`

---

## 📑 Daftar Isi
- [Topologi](#topologi)
- [Misi 1: VLSM & Routing](#misi-1-vlsm--routing)
  - [VLSM Tree](#vlsm-tree)
  - [Pembagian Subnet](#pembagian-subnet)
  - [Konfigurasi IP](#konfigurasi-ip)
  - [Routing](#routing)
  - [DNS Server (Narya)](#dns-server-narya)
  - [DHCP Server (Vilya)](#dhcp-server-vilya)
  - [DHCP Relay](#dhcp-relay)
  - [Web Server](#web-server)
- [Misi 2: Security Rules](#misi-2-security-rules)
  - [2.1 NAT Configuration](#21-nat-configuration)
  - [2.2 Blokir Ping ke Vilya](#22-blokir-ping-ke-vilya)
  - [2.3 DNS Hanya dari Vilya](#23-dns-hanya-dari-vilya)
  - [2.4 IronHills - Weekend Only](#24-ironhills---weekend-only)
  - [2.5 Palantir - Time-Based Access](#25-palantir---time-based-access)
  - [2.6 Port Scan Detection](#26-port-scan-detection)
  - [2.7 Connection Limiting](#27-connection-limiting)
  - [2.8 Traffic Redirection](#28-traffic-redirection)
- [Misi 3: Isolasi Khamul](#misi-3-isolasi-khamul)

---

## Topologi

<img width="1298" height="725" alt="image" src="https://github.com/user-attachments/assets/72c5883b-c8ad-435c-8f06-183ade3078cd" />

### Daftar Perangkat

| Perangkat   | Fungsi            | IP Address     |
| ----------- | ----------------- | -------------- |
| Osgiliath   | Router Utama      | -              |
| Moria       | Router            | 10.88.2.210    |
| Rivendell   | Router            | 10.88.2.214    |
| Minastir    | Router            | 10.88.2.218    |
| Pelargir    | Router            | 10.88.2.242    |
| AnduinBanks | Router            | 10.88.2.250    |
| Wilderland  | Router            | 10.88.2.222    |
| Vilya       | DHCP Server       | 10.88.2.202    |
| Narya       | DNS Server        | 10.88.2.203    |
| Palantir    | Web Server        | 10.88.2.246    |
| IronHills   | Web Server        | 10.88.2.226    |
| Elendil     | Client (200 host) | 10.88.0.0/24   |
| Isildur     | Client (30 host)  | 10.88.0.0/24   |
| Gilgalad    | Client (100 host) | 10.88.2.0/25   |
| Cirdan      | Client (20 host)  | 10.88.2.0/25   |
| Durin       | Client (50 host)  | 10.88.2.128/26 |
| Khamul      | Client (5 host)   | 10.88.2.192/29 |

---

## Misi 1: VLSM & Routing

### VLSM Tree

<img width="1408" height="999" alt="Untitled-2025-11-18-1127" src="https://github.com/user-attachments/assets/a74c51a5-e016-42d4-8206-da9ff2dbf262" />

### Pembagian Subnet

#### A. CLIENT SUBNETS

| Subnet | Client            | Network ID  | Netmask | Broadcast   | Range Usable              | Gateway     |
| ------ | ----------------- | ----------- | ------- | ----------- | ------------------------- | ----------- |
| **A1** | Elendil + Isildur | 10.88.0.0   | /24     | 10.88.0.255 | 10.88.0.2 - 10.88.0.254   | 10.88.0.1   |
| **A2** | Gilgalad + Cirdan | 10.88.2.0   | /25     | 10.88.2.127 | 10.88.2.2 - 10.88.2.126   | 10.88.2.1   |
| **A3** | Durin             | 10.88.2.128 | /26     | 10.88.2.191 | 10.88.2.130 - 10.88.2.190 | 10.88.2.129 |
| **A4** | Khamul            | 10.88.2.192 | /29     | 10.88.2.199 | 10.88.2.194 - 10.88.2.198 | 10.88.2.193 |

#### B. SERVER SUBNET

| Subnet | Server        | Network ID  | Netmask | IP Allocation                                                    |
| ------ | ------------- | ----------- | ------- | ---------------------------------------------------------------- |
| **A5** | Vilya + Narya | 10.88.2.200 | /29     | Gateway: 10.88.2.201<br>Vilya: 10.88.2.202<br>Narya: 10.88.2.203 |

#### C. ROUTER-TO-ROUTER SUBNETS (/30)

| Subnet  | Koneksi            | Network ID     | IP 1       | IP 2         |
| ------- | ------------------ | -------------- | ---------- | ------------ |
| **A6**  | Osg - Moria        | 10.88.2.208/30 | .209 (Osg) | .210 (Moria) |
| **A7**  | Osg - Rivendell    | 10.88.2.212/30 | .213 (Osg) | .214 (Riv)   |
| **A8**  | Osg - Minastir     | 10.88.2.216/30 | .217 (Osg) | .218 (Min)   |
| **A9**  | Moria - Wilderland | 10.88.2.220/30 | .221       | .222         |
| **A10** | Moria - IronHills  | 10.88.2.224/30 | .225       | .226         |
| **A11** | Min - Pelargir     | 10.88.2.240/30 | .241       | .242         |
| **A12** | Pel - Palantir     | 10.88.2.244/30 | .245       | .246         |
| **A13** | Pel - AnduinBanks  | 10.88.2.248/30 | .249       | .250         |

### Konfigurasi IP

Konfigurasi IP untuk semua perangkat disimpan di `/etc/network/interfaces`. Setiap router dan server memiliki IP static, sedangkan client menggunakan DHCP.

**Contoh konfigurasi Osgiliath:**
```ini
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 10.88.2.213
    netmask 255.255.255.252

auto eth2
iface eth2 inet static
    address 10.88.2.209
    netmask 255.255.255.252

auto eth3
iface eth3 inet static
    address 10.88.2.217
    netmask 255.255.255.252
```

### Routing

**Script routing di Osgiliath:**
```bash
#!/bin/bash
# /root/routing_osgiliath.sh

echo "[+] Setting static routes for Osgiliath..."

# Via Minastir
ip route add 10.88.0.0/24 via 10.88.2.218
ip route add 10.88.2.0/25 via 10.88.2.218
ip route add 10.88.2.240/30 via 10.88.2.218
ip route add 10.88.2.244/30 via 10.88.2.218
ip route add 10.88.2.248/30 via 10.88.2.218

# Via Moria
ip route add 10.88.2.128/26 via 10.88.2.210
ip route add 10.88.2.192/29 via 10.88.2.210
ip route add 10.88.2.220/30 via 10.88.2.210
ip route add 10.88.2.224/30 via 10.88.2.210

# Via Rivendell
ip route add 10.88.2.200/29 via 10.88.2.214

echo "[✓] Routing Osgiliath COMPLETE!"
```

### DNS Server (Narya)

<img width="745" height="1207" alt="image" src="https://github.com/user-attachments/assets/d70b3285-f8c2-4e0f-8ff3-38a085eaf260" />

**Script di Narya:**
```bash
#!/bin/bash

apt-get update
apt-get install bind9 -y

cat > /etc/bind/named.conf.options << 'EOF'
options {
    directory "/var/cache/bind";
    forwarders {
        8.8.8.8;
        1.1.1.1;
    };
    allow-query { any; };
    auth-nxdomain no;
    listen-on-v6 { any; };
};
EOF

service bind9 restart
echo "DNS Server ready!"
```

**Penjelasan:**
- Narya bertindak sebagai DNS Server untuk seluruh jaringan
- Menggunakan forwarder ke 8.8.8.8 dan 1.1.1.1 untuk resolve domain eksternal
- `allow-query { any; }` memperbolehkan semua client mengakses DNS

### DHCP Server (Vilya)

<img width="753" height="319" alt="image" src="https://github.com/user-attachments/assets/c17e6d2c-9c6a-4d04-93cb-76a5b6c7f2c1" />

**Script di Vilya:**
```bash
#!/bin/bash

apt-get update
apt-get install isc-dhcp-server -y

echo 'INTERFACESv4="eth0"' > /etc/default/isc-dhcp-server

cat > /etc/dhcp/dhcpd.conf << 'EOF'
option domain-name "aliansi.k49.com";
option domain-name-servers 10.88.2.203;
default-lease-time 600;
max-lease-time 7200;
authoritative;
ddns-update-style none;

# Khamul (5 host)
subnet 10.88.2.192 netmask 255.255.255.248 {
    range 10.88.2.194 10.88.2.198;
    option routers 10.88.2.193;
}

# Durin (50 host)
subnet 10.88.2.128 netmask 255.255.255.192 {
    range 10.88.2.130 10.88.2.190;
    option routers 10.88.2.129;
}

# Gilgalad + Cirdan (120 host)
subnet 10.88.2.0 netmask 255.255.255.128 {
    range 10.88.2.2 10.88.2.126;
    option routers 10.88.2.1;
}

# Elendil + Isildur (230 host)
subnet 10.88.0.0 netmask 255.255.255.0 {
    range 10.88.0.2 10.88.0.254;
    option routers 10.88.0.1;
}

# Subnet Vilya sendiri
subnet 10.88.2.200 netmask 255.255.255.248 {
}
EOF

service isc-dhcp-server restart
echo "DHCP Server ready!"
```

**Penjelasan:**
- Vilya mengalokasikan IP secara otomatis ke semua client
- Setiap subnet memiliki range IP dan gateway yang berbeda
- DNS server di-set ke Narya (10.88.2.203)

### DHCP Relay

DHCP Relay diperlukan di router yang tidak langsung terhubung ke Vilya untuk meneruskan request DHCP.

<img width="990" height="571" alt="image" src="https://github.com/user-attachments/assets/d91c7592-9a95-429a-adcf-c4b0d3cbadfd" />

<img width="992" height="577" alt="image" src="https://github.com/user-attachments/assets/7f429e5e-7e0c-4759-a6e4-d7c683f33253" />

<img width="990" height="572" alt="image" src="https://github.com/user-attachments/assets/3c2c28e8-b950-4f53-9179-ef048e167878" />

<img width="982" height="574" alt="image" src="https://github.com/user-attachments/assets/0dd0e3a6-06c1-44d1-a0ab-2d433f81216a" />

**Router yang membutuhkan DHCP Relay:**
- Rivendell (2 interface)
- Wilderland (3 interface)
- Minastir (3 interface)
- AnduinBanks (2 interface)

**Script di Wilderland (contoh):**
```bash
#!/bin/bash

apt-get update
apt-get install -y isc-dhcp-relay

cat > /etc/default/isc-dhcp-relay << 'EOF'
SERVERS="10.88.2.202"
INTERFACES="eth0 eth1 eth2"
OPTIONS=""
EOF

service isc-dhcp-relay restart
echo "DHCP Relay ready!"
```

**Penjelasan:**
- DHCP Relay meneruskan broadcast DHCP dari client ke Vilya (10.88.2.202)
- `INTERFACES` disesuaikan dengan jumlah interface di setiap router

### Web Server

<img width="991" height="552" alt="image" src="https://github.com/user-attachments/assets/269e494e-5e41-4281-af47-d1595d3ad09a" />

<img width="982" height="572" alt="image" src="https://github.com/user-attachments/assets/d736ddc1-bd06-4af0-a0ff-a47e9bf836e3" />

**Script di Palantir & IronHills:**
```bash
#!/bin/bash

apt-get update
apt-get install apache2 -y

HOSTNAME=$(hostname)
cat > /var/www/html/index.html << EOF
Welcome to $HOSTNAME
EOF

service apache2 start
echo "Web Server $HOSTNAME ready!"
```

**Penjelasan:**
- Palantir (10.88.2.246) dan IronHills (10.88.2.226) menjalankan Apache2
- Index page menampilkan nama hostname untuk identifikasi

---

## Misi 2: Security Rules

### 2.1 NAT Configuration

<img width="1041" height="1011" alt="image" src="https://github.com/user-attachments/assets/904e539e-260c-40ed-bc71-0d887c438ff1" />

**Console:** Osgiliath

**Script:**
```bash
#!/bin/bash

echo 1 > /proc/sys/net/ipv4/ip_forward

ETH0_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)

iptables -t nat -F
iptables -t nat -A POSTROUTING -s 10.88.0.0/16 -o eth0 -j SNAT --to-source $ETH0_IP

echo "NAT Configuration Complete!"
```

**Penjelasan:**
- NAT menggunakan **SNAT** (bukan MASQUERADE) sesuai ketentuan soal
- Semua traffic dari jaringan internal (10.88.0.0/16) di-translate ke IP eth0 Osgiliath
- IP forwarding harus diaktifkan agar router bisa meneruskan paket

**Testing:**
```bash
# Di client/router lain
ping 8.8.8.8  # Harus berhasil
```

---

### 2.2 Blokir Ping ke Vilya

<img width="1075" height="267" alt="image" src="https://github.com/user-attachments/assets/b3c05d09-e78b-481d-a4e6-17f0e74efd6a" />

<img width="846" height="136" alt="image" src="https://github.com/user-attachments/assets/e6b18d18-7652-4bbe-841e-2cd349c040b7" />

**Console:** Vilya

**Script:**
```bash
#!/bin/bash

iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
iptables -A OUTPUT -p icmp -j ACCEPT

echo "Vilya protected from ping!"
```

**Penjelasan:**
- Rule `INPUT` memblokir semua ICMP echo-request (ping) yang masuk ke Vilya
- Rule `OUTPUT` tetap memperbolehkan Vilya mengirim ping keluar
- Firewall menggunakan chain INPUT untuk traffic yang ditujukan ke Vilya sendiri

**Testing:**
```bash
# Dari client (harus FAIL)
ping 10.88.2.202

# Dari Vilya (harus SUCCESS)
ping 8.8.8.8
```

---

### 2.3 DNS Hanya dari Vilya

<img width="1180" height="420" alt="image" src="https://github.com/user-attachments/assets/448a4613-9ed6-4b8a-abae-69d4a7f8ebda" />

<img width="904" height="58" alt="image" src="https://github.com/user-attachments/assets/62c6f57b-d6c8-467f-8215-f0649ed40cd7" />

**Console:** Narya

**Script:**
```bash
#!/bin/bash

iptables -A INPUT -p tcp --dport 53 -s 10.88.2.202 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -s 10.88.2.202 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j DROP
iptables -A INPUT -p udp --dport 53 -j DROP

echo "DNS restricted to Vilya only!"
```

**Penjelasan:**
- Port 53 (DNS) hanya bisa diakses dari Vilya (10.88.2.202)
- TCP dan UDP port 53 di-filter karena DNS menggunakan kedua protokol
- Semua akses DNS dari IP lain akan di-DROP

**Testing:**
```bash
# Install netcat dulu
apt install netcat-openbsd -y

# Dari Vilya (harus SUCCESS)
nc -zvu 10.88.2.203 53

# Dari client (harus FAIL - timeout)
nc -zvu 10.88.2.203 53
```

**⚠️ PENTING:** Setelah testing, hapus rule dengan `iptables -F` agar DNS bisa diakses untuk install package!

---

### 2.4 IronHills - Weekend Only

<img width="769" height="74" alt="image" src="https://github.com/user-attachments/assets/be511828-87ca-4dff-a133-596ac9492102" />

<img width="1088" height="102" alt="image" src="https://github.com/user-attachments/assets/7595fe5d-6363-44b8-99ff-963e32c63e7d" />

**Console:** IronHills

**Script:**
```bash
#!/bin/bash

# Set waktu ke Rabu untuk testing
date -s "2025-11-26 12:00:00"

# Durin & Khamul (Kurcaci) - akses weekend
iptables -A INPUT -p tcp --dport 80 -s 10.88.2.128/26 -m time --weekdays Sa,Su -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -s 10.88.2.192/29 -m time --weekdays Sa,Su -j ACCEPT

# Elendil & Isildur (Manusia) - akses weekend
iptables -A INPUT -p tcp --dport 80 -s 10.88.0.0/24 -m time --weekdays Sa,Su -j ACCEPT

# DROP sisanya
iptables -A INPUT -p tcp --dport 80 -j DROP

echo "IronHills weekend-only configured!"
```

**Penjelasan:**
- Module `time` digunakan untuk membatasi akses berdasarkan hari
- `--weekdays Sa,Su` = hanya hari Sabtu dan Minggu
- Faksi Kurcaci (Durin & Khamul) dan Manusia (Elendil & Isildur) boleh akses
- Di hari selain weekend, semua akses ke port 80 akan di-DROP

**Testing:**
```bash
# Test di hari Rabu (harus FAIL)
curl http://10.88.2.226

# Ubah waktu ke Sabtu
date -s "2025-11-29 12:00:00"

# Test di hari Sabtu (harus SUCCESS)
curl http://10.88.2.226
# Output: Welcome to IronHills
```

---

### 2.5 Palantir - Time-Based Access

<img width="862" height="118" alt="image" src="https://github.com/user-attachments/assets/b8b85738-4f35-4b7d-8db3-065db6f3694b" />

<img width="867" height="45" alt="image" src="https://github.com/user-attachments/assets/40e3bff2-e395-464e-8175-e68e14b634ea" />

<img width="971" height="52" alt="image" src="https://github.com/user-attachments/assets/4877b265-3e2a-4720-b04e-5a55f31ba083" />

**Console:** Palantir

**Script:**
```bash
#!/bin/bash

# Elf: 07:00-15:00
iptables -A INPUT -p tcp --dport 80 -s 10.88.2.0/25 -m time --timestart 07:00 --timestop 15:00 -j ACCEPT

# Manusia: 17:00-23:00
iptables -A INPUT -p tcp --dport 80 -s 10.88.0.0/24 -m time --timestart 17:00 --timestop 23:00 -j ACCEPT

# REJECT sisanya
iptables -A INPUT -p tcp --dport 80 -j REJECT

echo "Palantir time-based access configured!"
```

**Penjelasan:**
- Faksi Elf (Gilgalad & Cirdan) hanya boleh akses jam 07:00-15:00
- Faksi Manusia (Elendil & Isildur) hanya boleh akses jam 17:00-23:00
- Di luar jam tersebut, akses akan di-REJECT (connection refused)
- Menggunakan REJECT bukan DROP agar client langsung tahu ditolak

**Testing:**
```bash
# Set waktu jam 10:00
date -s "2025-11-27 10:00:00"

# Dari Gilgalad (harus SUCCESS)
curl http://10.88.2.246

# Dari Elendil (harus FAIL)
curl http://10.88.2.246

# Set waktu jam 19:00
date -s "2025-11-27 19:00:00"

# Dari Elendil (harus SUCCESS)
curl http://10.88.2.246

# Dari Gilgalad (harus FAIL)
curl http://10.88.2.246
```

---

### 2.6 Port Scan Detection

<img width="1919" height="727" alt="image" src="https://github.com/user-attachments/assets/9892295b-9683-4b6f-bc83-750053bb4ef2" />

<img width="996" height="446" alt="image" src="https://github.com/user-attachments/assets/92860408-2ce6-49c1-ba8d-651c570d6f1e" />

**Console:** Palantir

**Script:**
```bash
#!/bin/bash

echo "[+] Installing ulogd2 for NFLOG logging..."
apt-get update
apt-get install -y ulogd2

echo "[+] Starting ulogd2..."
ulogd -d &

echo "[+] Flushing old rules..."
iptables -F
iptables -X PORTSCAN 2>/dev/null
iptables -N PORTSCAN

echo "[+] Applying port-scan rules..."

# Accept established + localhost
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT

# Detect scan: >15 ports in 20 seconds
iptables -A INPUT -p tcp --dport 1:100 -m recent --set --name portscan
iptables -A INPUT -p tcp --dport 1:100 -m recent --update --seconds 20 --hitcount 15 --name portscan -j PORTSCAN

# Log via NFLOG
iptables -A PORTSCAN -j NFLOG --nflog-prefix "PORT_SCAN_DETECTED: "

# Drop scanner
iptables -A PORTSCAN -j DROP

# Persistent block
iptables -A INPUT -m recent --rcheck --name portscan -j DROP

echo "[+] Port scan detection ACTIVE"
```

**Penjelasan:**
- Module `recent` mencatat IP yang melakukan koneksi ke port 1-100
- Jika ada **>15 port** di-scan dalam **20 detik**, dianggap port scan
- Scanner akan di-log menggunakan NFLOG (via ulogd2) dan di-DROP
- Scanner yang terdeteksi akan di-block permanen sampai reboot

**Testing:**
```bash
# Install nmap di client
apt install nmap -y

# Dari Elendil, scan Palantir
nmap -p 1-100 10.88.2.246

# Scan akan terhenti setelah ~15 port

# Cek log di Palantir
tail -f /var/log/ulog/syslogemu.log | grep PORT_SCAN

# Test apakah Elendil terblokir
ping 10.88.2.246  # Harus FAIL
curl http://10.88.2.246  # Harus FAIL
```

---

### 2.7 Connection Limiting

<img width="973" height="117" alt="image" src="https://github.com/user-attachments/assets/12441f37-3f36-45c2-80d1-985caed8bf42" />

<img width="1155" height="774" alt="image" src="https://github.com/user-attachments/assets/6b4f9dda-b352-4292-b264-8f106e9dbd76" />

**Console:** IronHills

**Script:**
```bash
#!/bin/bash

# Flush rules lama
iptables -F

# Set waktu ke Sabtu (agar bisa akses)
date -s "2025-11-29 12:00:00"

# Limit: max 3 koneksi per IP
iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above 3 --connlimit-mask 32 -j REJECT --reject-with tcp-reset

echo "Connection limit: 3 per IP"
```

**Penjelasan:**
- Module `connlimit` membatasi jumlah koneksi concurrent per IP
- `--connlimit-above 3` = maksimal 3 koneksi
- `--connlimit-mask 32` = per IP address (bukan per subnet)
- Koneksi ke-4 dan seterusnya akan di-REJECT dengan TCP RST

**Testing:**
```bash
# Dari Elendil, buat 5 koneksi sekaligus
for i in {1..5}; do curl http://10.88.2.226 & done

# Output:
# Welcome to IronHills (koneksi 1-3)
# curl: (7) Failed to connect (koneksi 4-5)
```

---

### 2.8 Traffic Redirection

<img width="760" height="96" alt="image" src="https://github.com/user-attachments/assets/45e9f59a-d338-4e89-a875-163a6c75e8b7" />

**Console:** Vilya

**Script:**
```bash
#!/bin/bash

iptables -t nat -A OUTPUT -d 10.88.2.192/29 -j DNAT --to-destination 10.88.2.226

echo "Traffic redirected: Khamul → IronHills"
```

**Penjelasan:**
- DNAT (Destination NAT) mengubah tujuan paket
- Semua traffic dari Vilya yang ditujukan ke subnet Khamul (10.88.2.192/29) akan di-redirect ke IronHills (10.88.2.226)
- Menggunakan chain OUTPUT karena traffic berasal dari Vilya sendiri

**Testing:**
```bash
# Install netcat di Vilya
apt install netcat-openbsd -y

# Test akses ke IP Khamul, tapi akan ke IronHills
nc -zv 10.88.2.194 80
# atau
curl http://10.88.2.194

# Output: Welcome to IronHills (bukan dari Khamul)

# Verifikasi NAT table
iptables -t nat -L OUTPUT -n -v
```

---

## Misi 3: Isolasi Khamul

<img width="927" height="305" alt="image" src="https://github.com/user-attachments/assets/010dd916-efd2-48ec-8675-8c16c118545d" />

<img width="1067" height="402" alt="image" src="https://github.com/user-attachments/assets/472985ee-9da7-422b-9cf6-ab45399877b2" />

**Console:** Wilderland

**Script:**
```bash
#!/bin/bash

# Reset iptables
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD
iptables -X

iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

# Loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# ESTABLISHED/RELATED
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# PENTING: Allow Durin DULU!
iptables -A FORWARD -s 10.88.2.128/26 -j ACCEPT
iptables -A FORWARD -d 10.88.2.128/26 -j ACCEPT
iptables -A INPUT -s 10.88.2.128/26 -j ACCEPT
iptables -A OUTPUT -d 10.88.2.128/26 -j ACCEPT

# DROP semua traffic Khamul
iptables -A INPUT -s 10.88.2.192/29 -j DROP
iptables -A OUTPUT -d 10.88.2.192/29 -j DROP
iptables -A FORWARD -s 10.88.2.192/29 -j DROP
iptables -A FORWARD -d 10.88.2.192/29 -j DROP

echo "=== Khamul ISOLATED ==="
```

**Penjelasan:**
- **CRITICAL:** Rule allow Durin harus ditambahkan SEBELUM rule block Khamul
- Subnet Durin (10.88.2.128/26) dan Khamul (10.88.2.192/29) sama-sama terhubung ke Wilderland
- Tanpa rule allow Durin, Durin juga akan terblokir karena subnet Khamul adalah bagian dari routing path
- Chain FORWARD digunakan karena Wilderland meneruskan traffic (bukan end-host)
- INPUT/OUTPUT di-block juga untuk mencegah akses langsung ke/dari
