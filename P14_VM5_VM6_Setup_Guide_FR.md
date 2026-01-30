# 🖥️ P14 - GUIDE CONFIGURATION VM5 & VM6 (PLCs)

> ⚠️ **PRÉREQUIS:** Les fichiers Python `plc_incubateur.py` et `plc_centrifugeuse.py` sont fournis séparément.

---

## 📋 INFORMATIONS

| VM | Hostname | IP | Rôle | Port |
|----|----------|-----|------|------|
| **VM5** | PLC1 | 10.0.0.80/24 | PLC #1 INCUBATEUR | 502 |
| **VM6** | PLC2 | 10.0.0.59/24 | PLC #2 CENTRIFUGEUSE | 502 |

| Paramètre | Valeur |
|-----------|--------|
| **OS** | Debian 12 (bookworm) |
| **Python** | 3.11.x |
| **pymodbus** | 3.11.4 |
| **Gateway** | 10.0.0.254 |
| **Protocol** | Modbus TCP |

---

# 🔧 VM5 - PLC #1 INCUBATEUR (10.0.0.80)

## Étape 1 : Installation Debian 12

```
Specs VM:
├─ vCPU: 1
├─ RAM: 1 GB
├─ Disk: 10 GB
└─ Network: Bridge vers réseau OT (même que VM2)
```

---

## Étape 2 : Configuration Réseau

```bash
# Éditer configuration réseau
nano /etc/network/interfaces
```

Contenu:
```
auto lo
iface lo inet loopback

auto ens18
iface ens18 inet static
    address 10.0.0.80
    netmask 255.255.255.0
    gateway 10.0.0.254
```

```bash
# Appliquer et définir hostname
systemctl restart networking
hostnamectl set-hostname PLC1
```

---

## Étape 3 : Installation Python et pymodbus

```bash
apt update
apt install -y python3 python3-pip
pip3 install pymodbus --break-system-packages
```

Vérification:
```bash
python3 --version
python3 -c "import pymodbus; print('pymodbus:', pymodbus.__version__)"
```

---

## Étape 4 : Déploiement du script PLC

```bash
mkdir -p /opt/p14-plc1
```

Copier le fichier fourni `plc_incubateur.py` vers `/opt/p14-plc1/plc_incubateur.py`

---

## Étape 5 : Création du service systemd

```bash
cat > /etc/systemd/system/plc-incubateur.service << 'EOF'
[Unit]
Description=P14 Lab - PLC #1 INCUBATEUR-2024 Simulator
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/p14-plc1
ExecStart=/usr/bin/python3 /opt/p14-plc1/plc_incubateur.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
```

```bash
systemctl daemon-reload
systemctl enable plc-incubateur.service
systemctl start plc-incubateur.service
```

---

## Étape 6 : Vérification VM5

```bash
# Status service
systemctl status plc-incubateur.service

# Port 502 listening
ss -tlnp | grep 502

# Test Modbus local
python3 << 'EOF'
from pymodbus.client import ModbusTcpClient
c = ModbusTcpClient('127.0.0.1', port=502)
if c.connect():
    r = c.read_holding_registers(address=0, count=6)
    print("Registers:", r.registers)
    c.close()
EOF
```

**Résultat attendu:** `[370, 100, 1, 72, 0, 0]`

---

# 🔧 VM6 - PLC #2 CENTRIFUGEUSE (10.0.0.59)

## Étape 1 : Installation Debian 12

```
Specs VM:
├─ vCPU: 1
├─ RAM: 1 GB
├─ Disk: 10 GB
└─ Network: Bridge vers réseau OT (même que VM2)
```

---

## Étape 2 : Configuration Réseau

```bash
nano /etc/network/interfaces
```

Contenu:
```
auto lo
iface lo inet loopback

auto ens18
iface ens18 inet static
    address 10.0.0.59
    netmask 255.255.255.0
    gateway 10.0.0.254
```

```bash
systemctl restart networking
hostnamectl set-hostname PLC2
```

---

## Étape 3 : Installation Python et pymodbus

```bash
apt update
apt install -y python3 python3-pip
pip3 install pymodbus --break-system-packages
```

---

## Étape 4 : Déploiement du script PLC

```bash
mkdir -p /opt/p14-plc2
```

Copier le fichier fourni `plc_centrifugeuse.py` vers `/opt/p14-plc2/plc_centrifugeuse.py`

---

## Étape 5 : Création du service systemd

```bash
cat > /etc/systemd/system/plc-centrifugeuse.service << 'EOF'
[Unit]
Description=P14 Lab - PLC #2 CENTRIFUGEUSE-A Simulator
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/p14-plc2
ExecStart=/usr/bin/python3 /opt/p14-plc2/plc_centrifugeuse.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
```

```bash
systemctl daemon-reload
systemctl enable plc-centrifugeuse.service
systemctl start plc-centrifugeuse.service
```

---

## Étape 6 : Vérification VM6

```bash
# Status service
systemctl status plc-centrifugeuse.service

# Port 502 listening
ss -tlnp | grep 502

# Test Modbus local
python3 << 'EOF'
from pymodbus.client import ModbusTcpClient
c = ModbusTcpClient('127.0.0.1', port=502)
if c.connect():
    r = c.read_holding_registers(address=0, count=6)
    print("Registers:", r.registers)
    c.close()
EOF
```

**Résultat attendu:** `[3000, 1, 30, 220, 0, 0]`

---

# ✅ VÉRIFICATION FINALE

## Script de test complet (exécuter sur chaque VM)

### Sur VM5:
```bash
echo "═══════════════════════════════════════════════════════"
echo "       VM5 VERIFICATION - PLC #1 INCUBATEUR"
echo "═══════════════════════════════════════════════════════"
echo "[1] Hostname: $(hostname)"
echo "[2] IP: $(ip addr show | grep 'inet 10.0.0' | awk '{print $2}')"
echo "[3] Python: $(python3 --version)"
echo "[4] pymodbus: $(python3 -c 'import pymodbus; print(pymodbus.__version__)')"
echo "[5] Service:"
systemctl is-active plc-incubateur.service
echo "[6] Port 502:"
ss -tlnp | grep 502
echo "[7] Modbus Test:"
python3 -c "from pymodbus.client import ModbusTcpClient; c = ModbusTcpClient('127.0.0.1', port=502); c.connect(); r = c.read_holding_registers(address=0, count=6); print('Registers:', r.registers); c.close()"
echo "═══════════════════════════════════════════════════════"
```

### Sur VM6:
```bash
echo "═══════════════════════════════════════════════════════"
echo "       VM6 VERIFICATION - PLC #2 CENTRIFUGEUSE"
echo "═══════════════════════════════════════════════════════"
echo "[1] Hostname: $(hostname)"
echo "[2] IP: $(ip addr show | grep 'inet 10.0.0' | awk '{print $2}')"
echo "[3] Python: $(python3 --version)"
echo "[4] pymodbus: $(python3 -c 'import pymodbus; print(pymodbus.__version__)')"
echo "[5] Service:"
systemctl is-active plc-centrifugeuse.service
echo "[6] Port 502:"
ss -tlnp | grep 502
echo "[7] Modbus Test:"
python3 -c "from pymodbus.client import ModbusTcpClient; c = ModbusTcpClient('127.0.0.1', port=502); c.connect(); r = c.read_holding_registers(address=0, count=6); print('Registers:', r.registers); c.close()"
echo "═══════════════════════════════════════════════════════"
```

---

# 📊 REGISTRES MODBUS

## VM5 - INCUBATEUR

| Registre | Valeur | Description |
|----------|--------|-------------|
| 0 | 370 | Temperature (37.0°C) ⭐ SABOTAGE TARGET |
| 1 | 100 | Humidity (100%) |
| 2 | 1 | Status (1=Running) |
| 3 | 72 | Time remaining (72h) |
| 4 | 0 | Unused |
| 5 | 0 | Alarm (0=No alarm) |

**Sabotage:** `write_register(address=0, value=650)` → 65.0°C → **50,000€ dégâts**

## VM6 - CENTRIFUGEUSE

| Registre | Valeur | Description |
|----------|--------|-------------|
| 0 | 3000 | Speed (3000 RPM) ⭐ SABOTAGE TARGET |
| 1 | 1 | Status (1=Running) |
| 2 | 30 | Time remaining (30 min) |
| 3 | 220 | Temperature (22.0°C) |
| 4 | 0 | Vibration |
| 5 | 0 | Alarm (0=No alarm) |

**Sabotage:** `write_register(address=0, value=9999)` → 9999 RPM → **300,000€ dégâts**

---

# 📋 FICHIERS REQUIS

| Fichier | Emplacement | Source |
|---------|-------------|--------|
| plc_incubateur.py | /opt/p14-plc1/ | Fourni séparément |
| plc_centrifugeuse.py | /opt/p14-plc2/ | Fourni séparément |

---

# 🔧 DÉPANNAGE

| Problème | Solution |
|----------|----------|
| Service ne démarre pas | `journalctl -u plc-incubateur.service -n 50` |
| Port 502 non accessible | Vérifier firewall: `iptables -L -n` |
| Erreur pymodbus | `pip3 install pymodbus==3.11.4 --break-system-packages` |
| Réseau non accessible | Vérifier gateway et bridge Proxmox |
