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

## Misi 1.4

### Narya

<img width="745" height="1207" alt="image" src="https://github.com/user-attachments/assets/d70b3285-f8c2-4e0f-8ff3-38a085eaf260" />

## Vilya

<img width="753" height="319" alt="image" src="https://github.com/user-attachments/assets/c17e6d2c-9c6a-4d04-93cb-76a5b6c7f2c1" />

## DHCP Relay (Rivendell, Wilderland, Minastir, dan AnduinBanks)

<img width="990" height="571" alt="image" src="https://github.com/user-attachments/assets/d91c7592-9a95-429a-adcf-c4b0d3cbadfd" />

<img width="992" height="577" alt="image" src="https://github.com/user-attachments/assets/7f429e5e-7e0c-4759-a6e4-d7c683f33253" />

<img width="990" height="572" alt="image" src="https://github.com/user-attachments/assets/3c2c28e8-b950-4f53-9179-ef048e167878" />

<img width="982" height="574" alt="image" src="https://github.com/user-attachments/assets/0dd0e3a6-06c1-44d1-a0ab-2d433f81216a" />

## Web Server (IronHills dan Palantir)

<img width="991" height="552" alt="image" src="https://github.com/user-attachments/assets/269e494e-5e41-4281-af47-d1595d3ad09a" />

<img width="982" height="572" alt="image" src="https://github.com/user-attachments/assets/d736ddc1-bd06-4af0-a0ff-a47e9bf836e3" />

---

## Misi 2: Security Rules

### Misi 2.1

<img width="1041" height="1011" alt="image" src="https://github.com/user-attachments/assets/904e539e-260c-40ed-bc71-0d887c438ff1" />

### Misi 2.2

<img width="1075" height="267" alt="image" src="https://github.com/user-attachments/assets/b3c05d09-e78b-481d-a4e6-17f0e74efd6a" />

<img width="846" height="136" alt="image" src="https://github.com/user-attachments/assets/e6b18d18-7652-4bbe-841e-2cd349c040b7" />

### Misi 2.3

<img width="1180" height="420" alt="image" src="https://github.com/user-attachments/assets/448a4613-9ed6-4b8a-abae-69d4a7f8ebda" />

<img width="904" height="58" alt="image" src="https://github.com/user-attachments/assets/62c6f57b-d6c8-467f-8215-f0649ed40cd7" />

### Misi 2.4

<img width="769" height="74" alt="image" src="https://github.com/user-attachments/assets/be511828-87ca-4dff-a133-596ac9492102" />

<img width="1088" height="102" alt="image" src="https://github.com/user-attachments/assets/7595fe5d-6363-44b8-99ff-963e32c63e7d" />

### Misi 2.5

### Misi 2.6

### Misi 2.7

### Misi 2.8



