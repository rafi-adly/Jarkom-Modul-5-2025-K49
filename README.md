# Jarkom-Modul-5-2025-K49

| Nama                       | NRP        |
| -------------------------- | ---------- |
| Revalina Erica Permatasari | 5027241007 |
| Muhammad Rafi` Adly        | 5027241082 |

**Prefix IP**
`10.88.x.x`

---

## Daftar Isi
- [Topologi](#topologi)
- [Misi 1: VLSM & Routing](#misi-1-vlsm--routing)
- [Misi 2: Security Rules](#misi-2-security-rules)
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

### Client Requirements

| Subnet | Client            | Total Host Needed           | Netmask | Usable Host |
| ------ | ----------------- | --------------------------- | ------- | ----------- |
| **A1** | Elendil + Isildur | 200 + 30 = **230**          | **/24** | 254         |
| **A2** | Gilgalad + Cirdan | 100 + 20 = **120**          | **/25** | 126         |
| **A3** | Durin             | **50**                      | **/26** | 62          |
| **A4** | Khamul            | **5**                       | **/29** | 6           |
| **A5** | Vilya + Narya     | **3** (2 server + 1 router) | **/29** | 6           |

### Router-to-Router (/30)

Total **12 koneksi /30**:

* Osg → Moria, Rivendell, Minastir (3)
* Moria → Wilderland, IronHills (2)
* Wilderland → Khamul (1)
* Minastir → Pelargir (1)
* Pelargir → AnduinBanks, Palantir (2)
* AnduinBanks → Gilgalad+Cirdan (1)
* Rivendell → Vilya+Narya (1)
* Minastir → Elendil+Isildur (1)

---

## VLSM TREE

<img width="1408" height="999" alt="Untitled-2025-11-18-1127" src="https://github.com/user-attachments/assets/a74c51a5-e016-42d4-8206-da9ff2dbf262" />

A1: 10.88.0.0/24

A2: 10.88.2.0/25

A3: 10.88.2.128/26

A4: 10.88.2.192/29

A5: 10.88.2.200/29

Router links: 10.88.2.208, dst

---

### A. CLIENT SUBNETS

| Label  | Client            | Network ID  | Netmask | Broadcast   | Range Usable              | Gateway     | Host |
| ------ | ----------------- | ----------- | ------- | ----------- | ------------------------- | ----------- | ---- |
| **A1** | Elendil + Isildur | 10.88.0.0   | /24     | 10.88.0.255 | 10.88.0.2 - 10.88.0.254   | 10.88.0.1   | 230  |
| **A2** | Gilgalad + Cirdan | 10.88.2.0   | /25     | 10.88.2.127 | 10.88.2.2 - 10.88.2.126   | 10.88.2.1   | 120  |
| **A3** | Durin             | 10.88.2.128 | /26     | 10.88.2.191 | 10.88.2.130 - 10.88.2.190 | 10.88.2.129 | 50   |
| **A4** | Khamul            | 10.88.2.192 | /29     | 10.88.2.199 | 10.88.2.194 - 10.88.2.198 | 10.88.2.193 | 5    |

### B. SERVER SUBNET

| Label  | Server        | Network ID  | Netmask | Broadcast   | IP Allocation                                                    | Host |
| ------ | ------------- | ----------- | ------- | ----------- | ---------------------------------------------------------------- | ---- |
| **A5** | Vilya + Narya | 10.88.2.200 | /29     | 10.88.2.207 | Gateway: 10.88.2.201<br>Vilya: 10.88.2.202<br>Narya: 10.88.2.203 | 3    |

### C. ROUTER-TO-ROUTER SUBNETS (/30)

| Label   | Koneksi            | Network ID     | Netmask | IP 1       | IP 2         | Broadcast |
| ------- | ------------------ | -------------- | ------- | ---------- | ------------ | --------- |
| **A6**  | Osg - Moria        | 10.88.2.208/30 | /30     | .209 (Osg) | .210 (Moria) | .211      |
| **A7**  | Osg - Riv          | 10.88.2.212/30 | /30     | .213 (Osg) | .214 (Riv)   | .215      |
| **A8**  | Osg - Min          | 10.88.2.216/30 | /30     | .217 (Osg) | .218 (Min)   | .219      |
| **A9**  | Moria - Wilderland | 10.88.2.220/30 | /30     | .221       | .222         | .223      |
| **A10** | Moria - IronHills  | 10.88.2.224/30 | /30     | .225       | .226         | .227      |
| **A11** | Min - Pelargir     | 10.88.2.240/30 | /30     | .241       | .242         | .243      |
| **A12** | Pel - Palantir     | 10.88.2.244/30 | /30     | .245       | .246         | .247      |
| **A13** | Pel - AnduinBanks  | 10.88.2.248/30 | /30     | .249       | .250         | .251      |

---

## IP

### Server

* Vilya (DHCP): 10.88.2.202/29
* Narya (DNS): 10.88.2.203/29
* Palantir (Web): 10.88.2.246/30
* IronHills (Web): 10.88.2.226/30

### Client Gateways

* Elendil+Isildur: 10.88.0.1
* Gilgalad+Cirdan: 10.88.2.1
* Durin: 10.88.2.129
* Khamul: 10.88.2.193

### DNS

* 10.88.2.203

---

## TOTAL USAGE

| Jenis          | Jumlah | IP Used    |
| -------------- | ------ | ---------- |
| Client Subnets | 5      | 405        |
| Server Subnet  | 1      | 3          |
| Router /30     | 12     | 24         |
| **TOTAL**      | **18** | **432 IP** |

Tersisa >65 ribu IP untuk ekspansi.

---

## Misi 2: Security Rules

### 2.1

<img width="1041" height="1011" alt="image" src="https://github.com/user-attachments/assets/904e539e-260c-40ed-bc71-0d887c438ff1" />
