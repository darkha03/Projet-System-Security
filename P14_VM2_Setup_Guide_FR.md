# 🖥️ P14 - GUIDE CONFIGURATION VM2 (SRV-SCADA)

> ⚠️ **ORDRE D'EXÉCUTION IMPORTANT:**
> 1. Étapes 1-8: Configuration de base (réseau, comptes, Python, service)
> 2. Étape 9: Règles pare-feu (APRÈS création du service)
> 3. Étapes 10-11: Restrictions NTFS (APRÈS compilation .exe)
> 4. Étapes 12-14: Vérifications

## 📋 INFORMATIONS

| Paramètre | Valeur |
|-----------|--------|
| **Hostname** | P14-SCADA-OT |
| **IP** | 10.0.0.10/24 |
| **Gateway** | 10.0.0.254 |
| **DNS** | 8.8.8.8 |
| **OS** | Windows Server 2022 (Français) |
| **Rôle** | Serveur SCADA - HMI + API Modbus |
| **Zone** | OT Zone |

---

## 🔧 ÉTAPE 1 : CONFIGURATION RÉSEAU

```powershell
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 10.0.0.10 -PrefixLength 24 -DefaultGateway 10.0.0.254
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "8.8.8.8","8.8.4.4"
Rename-Computer -NewName "P14-SCADA-OT" -Force
Restart-Computer -Force
```

---

## 👤 ÉTAPE 2 : COMPTES UTILISATEURS

```powershell
# Créer scada_user (utilisateur standard + RDP)
net user scada_user "Secure2024@!" /add
net localgroup "Utilisateurs" scada_user /add
net localgroup "Utilisateurs du Bureau à distance" scada_user /add

# Créer scada_admin (administrateur)
net user scada_admin "Scada2024" /add
net localgroup "Administrateurs" scada_admin /add
```

### Comptes finaux

| Compte | Mot de passe | Groupes | Rôle |
|--------|--------------|---------|------|
| scada_user | Secure2024@! | Utilisateurs + RDP Users | Cible mouvement latéral |
| scada_admin | Scada2024 | Administrateurs | Admin post-escalade |

---

## 🌐 ÉTAPE 3 : INSTALLER IIS

```powershell
Install-WindowsFeature -Name Web-Server -IncludeManagementTools -IncludeAllSubFeature
Get-Service W3SVC
```

---

## 🐍 ÉTAPE 4 : INSTALLER PYTHON

### 4.1 Télécharger Python

```
https://www.python.org/downloads/
→ Python 3.12.x Windows installer (64-bit)
```

### 4.2 Installation

```
✅ Add Python to PATH
✅ Install for all users
→ Customize installation
→ Install location: C:\Program Files\Python312
```

### 4.3 Installer les dépendances

```powershell
pip install pymodbus flask flask-cors pyinstaller
pip list | findstr "pymodbus flask pyinstaller"
```

---

## 📁 ÉTAPE 5 : STRUCTURE DES DOSSIERS

```powershell
New-Item -Path "C:\SCADA" -ItemType Directory -Force
New-Item -Path "C:\SCADA\HMI" -ItemType Directory -Force
New-Item -Path "C:\SCADA\HMI\api" -ItemType Directory -Force
New-Item -Path "C:\SCADA\HMI\web" -ItemType Directory -Force
New-Item -Path "C:\SCADA\HMI\logs" -ItemType Directory -Force
New-Item -Path "C:\SCADA\Data" -ItemType Directory -Force
New-Item -Path "C:\Tools" -ItemType Directory -Force
```

---

## 📄 ÉTAPE 6 : COPIER LES FICHIERS ET CONFIGURER IIS

### 6.1 Copier les fichiers fournis

```
C:\SCADA\HMI\api\scada_api.py      ← API Flask (fourni séparément)
C:\SCADA\HMI\web\index.html        ← Dashboard HMI (fourni séparément)
$apiCode = @'
"""
SCADA HMI API  v1.5
BioTech Solutions - Laboratory Monitoring System
MAPPING BASED ON ACTUAL PLC REGISTER DATA
"""

from flask import Flask, jsonify
from flask_cors import CORS
from pymodbus.client import ModbusTcpClient
import logging
from datetime import datetime

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
log = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app)

PLC_CONFIG = {
    1: {
        "name": "INCUBATEUR-2024",
        "ip": "10.0.0.80",
        "port": 502,
        "type": "temperature",
        "unit": "°C",
        "normal_min": 35.0,
        "normal_max": 39.0,
        "critical_max": 50.0
    },
    2: {
        "name": "CENTRIFUGEUSE-A",
        "ip": "10.0.0.59",
        "port": 502,
        "type": "speed",
        "unit": "RPM",
        "normal_min": 1000,
        "normal_max": 4000,
        "critical_max": 6000
    }
}

def get_status(value, config):
    if config["type"] == "temperature":
        actual = value / 10.0
    else:
        actual = value

    if actual > config["critical_max"]:
        return "CRITICAL"
    elif actual > config["normal_max"] or actual < config["normal_min"]:
        return "WARNING"
    else:
        return "NORMAL"

def read_plc(plc_id):
    if plc_id not in PLC_CONFIG:
        return None
    
    config = PLC_CONFIG[plc_id]
    client = None

    try:
        client = ModbusTcpClient(config["ip"], port=config["port"])

        if not client.connect():
            log.error(f"Cannot connect to PLC {plc_id}")
            return None

        result = client.read_holding_registers(address=0, count=6)

        if result.isError():
            log.error(f"Modbus error: {result}")
            return None

        r = result.registers
        log.info(f"PLC{plc_id} raw: {r}")

        status = get_status(r[0], config)

        if config["type"] == "temperature":
            # PLC1 INCUBATEUR - ACTUAL REGISTER MAPPING:
            # [0]=370   Temperature (37.0°C)
            # [1]=100   Humidity (100%)
            # [2]=1     Status (1=Running)
            # [3]=72    Time remaining (72h)
            # [4]=0     Unused
            # [5]=0     Alarm
            return {
                "id": plc_id,
                "name": config["name"],
                "type": config["type"],
                "status": status,
                "data": {
                    "setpoint": r[0] / 10.0,
                    "current": r[0] / 10.0,
                    "humidity": r[1],
                    "running": r[2] == 1,
                    "time_remaining": r[3],
                    "alarm": r[5] == 1
                },
                "unit": config["unit"],
                "timestamp": datetime.now().isoformat()
            }
        else:
            # PLC2 CENTRIFUGEUSE - ACTUAL REGISTER MAPPING:
            # [0]=3000  Speed (3000 RPM)
            # [1]=1     Status (1=Running)
            # [2]=30    Time remaining (30 min)
            # [3]=220   Temperature (22.0°C)
            # [4]=0     Vibration
            # [5]=0     Alarm
            return {
                "id": plc_id,
                "name": config["name"],
                "type": config["type"],
                "status": status,
                "data": {
                    "setpoint": r[0],
                    "current": r[0],
                    "running": r[1] == 1,
                    "time_remaining": r[2],
                    "temperature": r[3] / 10.0,
                    "vibration": r[4],
                    "alarm": r[5] == 1
                },
                "unit": config["unit"],
                "timestamp": datetime.now().isoformat()
            }

    except Exception as e:
        log.error(f"Error: {e}")
        return None
    finally:
        if client:
            client.close()

@app.route('/')
def home():
    return jsonify({"service": "SCADA HMI API", "version": "1.5"})

@app.route('/api/plc/<int:plc_id>')
def get_plc(plc_id):
    data = read_plc(plc_id)
    return jsonify(data) if data else (jsonify({"error": f"PLC {plc_id} offline"}), 500)

@app.route('/api/plc/all')
def get_all_plcs():
    result = {"timestamp": datetime.now().isoformat(), "plcs": []}

    for plc_id in PLC_CONFIG:
        data = read_plc(plc_id)
        if data:
            result["plcs"].append(data)
        else:
            result["plcs"].append({
                "id": plc_id,
                "name": PLC_CONFIG[plc_id]["name"],
                "status": "OFFLINE"
            })

    statuses = [p.get("status", "OFFLINE") for p in result["plcs"]]
    if "CRITICAL" in statuses:
        result["overall_status"] = "CRITICAL"
    elif "WARNING" in statuses or "OFFLINE" in statuses:
        result["overall_status"] = "WARNING"
    else:
        result["overall_status"] = "NORMAL"

    return jsonify(result)

if __name__ == '__main__':
    log.info("=" * 50)
    log.info("SCADA HMI API v1.5 - Correct Mapping")
    log.info("=" * 50)
    app.run(host='0.0.0.0', port=5000)
'@

$apiCode | Out-File "C:\SCADA\HMI\api\scada_api.py" -Encoding UTF8
Write-Host "[OK] Created C:\SCADA\HMI\api\scada_api.py" -ForegroundColor Green

$htmlCode = @'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SCADA HMI - BioTech Lab Monitoring</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            min-height: 100vh;
            color: #fff;
        }

        .header {
            background: rgba(0,0,0,0.3);
            padding: 20px;
            text-align: center;
            border-bottom: 2px solid #0f3460;
        }

        .header h1 {
            font-size: 24px;
            color: #00d4ff;
            margin-bottom: 5px;
        }

        .header .subtitle {
            color: #888;
            font-size: 14px;
        }

        .status-bar {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 15px;
            gap: 30px;
            background: rgba(0,0,0,0.2);
        }

        .status-indicator {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .status-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        .status-dot.normal { background: #00ff88; }
        .status-dot.warning { background: #ffaa00; }
        .status-dot.critical { background: #ff4444; animation: pulse-critical 0.5s infinite; }
        .status-dot.offline { background: #666; }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }

        @keyframes pulse-critical {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.7; transform: scale(1.2); }
        }

        .dashboard {
            display: flex;
            justify-content: center;
            gap: 40px;
            padding: 40px;
            flex-wrap: wrap;
        }

        .plc-card {
            background: rgba(255,255,255,0.05);
            border-radius: 20px;
            padding: 30px;
            min-width: 350px;
            border: 1px solid rgba(255,255,255,0.1);
            transition: all 0.3s ease;
        }
        
        .plc-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 40px rgba(0,212,255,0.2);
        }

        .plc-card.warning {
            border-color: #ffaa00;
            box-shadow: 0 0 20px rgba(255,170,0,0.3);
        }

        .plc-card.critical {
            border-color: #ff4444;
            box-shadow: 0 0 30px rgba(255,68,68,0.5);
            animation: shake 0.5s infinite;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        .plc-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .plc-name {
            font-size: 18px;
            font-weight: 600;
        }

        .plc-status {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .plc-status.normal { background: #00ff88; color: #000; }
        .plc-status.warning { background: #ffaa00; color: #000; }
        .plc-status.critical { background: #ff4444; color: #fff; }
        .plc-status.offline { background: #666; color: #fff; }

        .main-value {
            text-align: center;
            padding: 30px 0;
        }

        .main-value .value {
            font-size: 64px;
            font-weight: 700;
            color: #00d4ff;
        }
        
        .main-value .unit {
            font-size: 24px;
            color: #888;
            margin-left: 5px;
        }

        .main-value.warning .value { color: #ffaa00; }
        .main-value.critical .value { color: #ff4444; }

        .plc-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .detail-item {
            background: rgba(0,0,0,0.2);
            padding: 15px;
            border-radius: 10px;
        }

        .detail-item .label {
            font-size: 11px;
            color: #888;
            text-transform: uppercase;
            margin-bottom: 5px;
        }

        .detail-item .value {
            font-size: 18px;
            font-weight: 600;
        }

        .footer {
            text-align: center;
            padding: 20px;
            color: #666;
            font-size: 12px;
        }

        .alert-banner {
            display: none;
            background: #ff4444;
            color: #fff;
            padding: 15px;
            text-align: center;
            font-weight: 600;
            animation: flash 1s infinite;
        }
        
        .alert-banner.active {
            display: block;
        }

        @keyframes flash {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }
        
        .loading {
            text-align: center;
            padding: 100px;
            color: #888;
        }

        .error {
            background: rgba(255,68,68,0.2);
            border: 1px solid #ff4444;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            margin: 20px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1> SCADA HMI - Laboratory Monitoring System</h1>
        <div class="subtitle">BioTech Solutions - Real-time Equipment Monitoring</div>
    </div>
    
    <div class="alert-banner" id="alertBanner">
         CRITICAL ALERT - IMMEDIATE ATTENTION REQUIRED
    </div>

    <div class="status-bar">
        <div class="status-indicator">
            <div class="status-dot" id="overallStatus"></div>
            <span>System Status: <strong id="overallStatusText">Loading...</strong></span>
        </div>
        <div class="status-indicator">
            <span>Last Update: <strong id="lastUpdate">--:--:--</strong></span>
        </div>
        <div class="status-indicator">
            <span>Auto-refresh: <strong>5 seconds</strong></span>
        </div>
    </div>

    <div class="dashboard" id="dashboard">
        <div class="loading">
            <h2> Connecting to PLCs...</h2>
            <p>Please wait while establishing Modbus connections</p>
        </div>
    </div>

    <div class="footer">
        <p>SCADA Monitor Pro v3.2.1 |  2024 BioTech Solutions | For authorized personnel only</p>
    </div>

    <script>
        const API_URL = 'http://localhost:5000';
        
        function getStatusClass(status) {
            return status ? status.toLowerCase() : 'offline';
        }

        function formatTime(isoString) {
            const date = new Date(isoString);
            return date.toLocaleTimeString();
        }

        function createPLCCard(plc) {
            const statusClass = getStatusClass(plc.status);
            const isTemperature = plc.type === 'temperature';

            let mainValue, mainUnit;
            if (plc.status === 'OFFLINE') {
                mainValue = '--';
                mainUnit = '';
            } else if (isTemperature) {
                mainValue = plc.data.current.toFixed(1);
                mainUnit = plc.unit;
            } else {
                mainValue = plc.data.current;
                mainUnit = plc.unit;
            }

            let detailsHTML = '';
            if (plc.data) {
                if (isTemperature) {
                    detailsHTML = `
                        <div class="detail-item">
                            <div class="label">Setpoint</div>
                            <div class="value">${plc.data.setpoint.toFixed(1)}${plc.unit}</div>
                        </div>
                        <div class="detail-item">
                            <div class="label">Humidity</div>
                            <div class="value">${plc.data.humidity}%</div>
                        </div>
                        <div class="detail-item">
                            <div class="label">Status</div>
                            <div class="value">${plc.data.running ? ' Running' : ' Stopped'}</div>
                        </div>
                        <div class="detail-item">
                            <div class="label">Time Remaining</div>
                            <div class="value">${plc.data.time_remaining}h</div>
                        </div>
                    `;
                } else {
                    detailsHTML = `
                        <div class="detail-item">
                            <div class="label">Setpoint</div>
                            <div class="value">${plc.data.setpoint} ${plc.unit}</div>
                        </div>
                        <div class="detail-item">
                            <div class="label">Temperature</div>
                            <div class="value">${plc.data.temperature.toFixed(1)}°C</div>
                        </div>
                        <div class="detail-item">
                            <div class="label">Status</div>
                            <div class="value">${plc.data.running ? ' Running' : ' Stopped'}</div>
                        </div>
                        <div class="detail-item">
                            <div class="label">Time Remaining</div>
                            <div class="value">${plc.data.time_remaining} min</div>
                        </div>
                    `;
                }
            }

            return `
                <div class="plc-card ${statusClass}">
                    <div class="plc-header">
                        <div class="plc-name">${isTemperature ? '' : ''} ${plc.name}</div>
                        <div class="plc-status ${statusClass}">${plc.status || 'OFFLINE'}</div>
                    </div>
                    <div class="main-value ${statusClass}">
                        <span class="value">${mainValue}</span>
                        <span class="unit">${mainUnit}</span>
                    </div>
                    <div class="plc-details">
                        ${detailsHTML}
                    </div>
                </div>
            `;
        }

        async function updateDashboard() {
            try {
                const response = await fetch(`${API_URL}/api/plc/all`);
                const data = await response.json();

                // Update dashboard
                const dashboard = document.getElementById('dashboard');
                dashboard.innerHTML = data.plcs.map(plc => createPLCCard(plc)).join('');

                // Update status bar
                const overallStatus = document.getElementById('overallStatus');
                const overallStatusText = document.getElementById('overallStatusText');
                const statusClass = getStatusClass(data.overall_status);

                overallStatus.className = `status-dot ${statusClass}`;
                overallStatusText.textContent = data.overall_status;

                // Update timestamp
                document.getElementById('lastUpdate').textContent = formatTime(data.timestamp);

                // Show/hide alert banner
                const alertBanner = document.getElementById('alertBanner');
                if (data.overall_status === 'CRITICAL') {
                    alertBanner.classList.add('active');
                } else {
                    alertBanner.classList.remove('active');
                }

            } catch (error) {
                console.error('Error fetching PLC data:', error);
                document.getElementById('dashboard').innerHTML = `
                    <div class="error">
                        <h2> Connection Error</h2>
                        <p>Cannot connect to SCADA API server</p>
                        <p>Please ensure the API service is running</p>
                        <p style="color: #888; margin-top: 10px;">Error: ${error.message}</p>
                    </div>
                `;
            }
        }

        // Initial update
        updateDashboard();

        // Auto-refresh every 5 seconds
        setInterval(updateDashboard, 5000);
    </script>
</body>
</html>
'@

$htmlCode | Out-File "C:\SCADA\HMI\web\index.html" -Encoding UTF8
Write-Host "[OK] Created C:\SCADA\HMI\web\index.html" -ForegroundColor Green
```

### 6.2 Déployer vers IIS

```powershell
# Backup page IIS par défaut
if (Test-Path "C:\inetpub\wwwroot\iisstart.htm") {
    Move-Item "C:\inetpub\wwwroot\iisstart.htm" "C:\inetpub\wwwroot\iisstart.htm.bak" -Force
}

# Copier HMI vers IIS
Copy-Item "C:\SCADA\HMI\web\index.html" "C:\inetpub\wwwroot\index.html" -Force

# Vérifier IIS fonctionne
Start-Process "http://localhost"
```

---

## ⚙️ ÉTAPE 7 : COMPILER L'API EN .EXE

```powershell
cd C:\SCADA\HMI\api
pyinstaller --onefile --name scada_api scada_api.py
Copy-Item "C:\SCADA\HMI\api\dist\scada_api.exe" "C:\SCADA\HMI\api\scada_api.exe"
```

---

## 🔧 ÉTAPE 8 : INSTALLER NSSM ET CRÉER LE SERVICE

### 8.1 Télécharger NSSM

```powershell
New-Item -ItemType Directory -Path "C:\Tools" -Force
Invoke-WebRequest -Uri "https://nssm.cc/release/nssm-2.24.zip" -OutFile "C:\Tools\nssm.zip"
Invoke-WebRequest -Uri "https://nssm.cc/release/nssm-2.24.zip" -OutFile "C:\Tools\nssm.zip"

Expand-Archive -Path "C:\Tools\nssm.zip" -DestinationPath "C:\Tools\" -Force

Copy-Item "C:\Tools\nssm-2.24\win64\nssm.exe" "C:\Windows\System32\nssm.exe" -Force

nssm version
```

### 8.2 Créer le service SCADA_API

```powershell
nssm install SCADA_API "C:\SCADA\HMI\api\scada_api.exe"
nssm set SCADA_API DisplayName "SCADA HMI API Service"
nssm set SCADA_API Description "BioTech Solutions - SCADA Modbus API Server"
nssm set SCADA_API AppDirectory "C:\SCADA\HMI\api"
nssm set SCADA_API Start SERVICE_AUTO_START
nssm set SCADA_API AppStdout "C:\SCADA\HMI\logs\api_stdout.log"
nssm set SCADA_API AppStderr "C:\SCADA\HMI\logs\api_stderr.log"
nssm start SCADA_API
```

### 8.3 Vérifier

```powershell
Get-Service SCADA_API
Invoke-RestMethod -Uri "http://localhost:5000/api/plc/all"
```

---

## 🛡️ ÉTAPE 9 : RÈGLES PARE-FEU

### 9.1 Règles Inbound

```powershell
# Autoriser Ping
New-NetFirewallRule -DisplayName "P14-Allow-Ping" -Direction Inbound -Protocol ICMPv4 -Action Allow

# Autoriser RDP uniquement depuis VM1 (10.0.0.45)
New-NetFirewallRule -DisplayName "P14-Allow-Maintenance-VM1" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 3389 -RemoteAddress 10.0.0.45

# Bloquer la zone IT (sauf VM1)
New-NetFirewallRule -DisplayName "P14-Block-IT-Zone" -Direction Inbound -Action Block -Protocol TCP -LocalPort 80,443,502,3389,445 -RemoteAddress 10.0.0.40-10.0.0.44,10.0.0.46-10.0.0.50

# Autoriser API port 5000
New-NetFirewallRule -DisplayName "P14-Allow-API-5000" -Direction Inbound -Protocol TCP -LocalPort 5000 -Action Allow
```

### 9.2 Règles Outbound Modbus (CRITIQUE!)

**But:** Bloquer l'accès Modbus pour tous SAUF scada_api.exe

```powershell
# Autoriser Modbus UNIQUEMENT pour scada_api.exe
New-NetFirewallRule -DisplayName "P14-Allow-Modbus-SCADA-API" `
    -Direction Outbound -Action Allow -Protocol TCP -RemotePort 502 `
    -Program "C:\SCADA\HMI\api\scada_api.exe"

# Bloquer Modbus pour Python
New-NetFirewallRule -DisplayName "P14-Block-Modbus-Python" `
    -Direction Outbound -Action Block -Protocol TCP -RemotePort 502 `
    -Program "C:\Program Files\Python312\python.exe"

# Bloquer Modbus pour PowerShell
New-NetFirewallRule -DisplayName "P14-Block-Modbus-PowerShell" `
    -Direction Outbound -Action Block -Protocol TCP -RemotePort 502 `
    -Program "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"

# Bloquer Modbus pour CMD
New-NetFirewallRule -DisplayName "P14-Block-Modbus-CMD" `
    -Direction Outbound -Action Block -Protocol TCP -RemotePort 502 `
    -Program "C:\Windows\System32\cmd.exe"
```

### 9.3 Vérifier les règles

```powershell
Get-NetFirewallRule -DisplayName "P14*" | Select-Object DisplayName, Enabled, Direction, Action | Format-Table -AutoSize
```

---

## 🔒 ÉTAPE 10 : RESTREINDRE PYTHON (CRITIQUE!)

> ⚠️ **IMPORTANT:** Exécuter cette étape APRÈS avoir compilé scada_api.exe (Étape 7) et créé le service (Étape 8)!

**But:** Empêcher scada_user d'exécuter Python → Force l'utilisation de PrintNightmare

```powershell
# Prendre possession
takeown /F "C:\Program Files\Python312" /R /A

# Supprimer héritage et définir permissions
icacls "C:\Program Files\Python312" /inheritance:r
icacls "C:\Program Files\Python312" /grant:r "BUILTIN\Administrateurs:(OI)(CI)F"
icacls "C:\Program Files\Python312" /grant:r "AUTORITE NT\Système:(OI)(CI)F"
icacls "C:\Program Files\Python312" /grant:r "BUILTIN\Utilisateurs:(OI)(CI)R"

# Vérifier
icacls "C:\Program Files\Python312\python.exe"
```

**Résultat attendu :**
- Administrateurs : Full (F)
- SYSTEM : Full (F)
- Utilisateurs : Read only (R) → **Pas d'exécution!**

---

## 🔒 ÉTAPE 11 : RESTREINDRE CURL.EXE (CRITIQUE!)

**But:** Empêcher scada_user de contourner le pare-feu avec curl

```powershell
takeown /F "C:\Windows\System32\curl.exe" /A
icacls "C:\Windows\System32\curl.exe" /inheritance:r
icacls "C:\Windows\System32\curl.exe" /grant:r "BUILTIN\Administrateurs:(RX)"
icacls "C:\Windows\System32\curl.exe" /grant:r "AUTORITE NT\Système:(RX)"
icacls "C:\Windows\System32\curl.exe" /grant:r "BUILTIN\Utilisateurs:(R)"

# Vérifier
icacls "C:\Windows\System32\curl.exe"
```

---

## 🖨️ ÉTAPE 12 : PRINTNIGHTMARE (VULNÉRABILITÉ)

### 12.1 Vérifier Print Spooler actif

```powershell
Get-Service Spooler | Select-Object Name, Status, StartType
# Doit être: Running, Automatic
```

### 12.2 Vérifier absence de patches

```powershell
Get-HotFix | Where-Object {$_.HotFixID -match "KB5004945|KB5004946|KB5004947|KB5004948|KB5004950"}
# Doit retourner: AUCUN résultat
```

### 12.3 Vérifier Registry (doit être absent ou =0)

```powershell
$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint"
Test-Path $path
# Doit être: False (inexistant = vulnérable)
```

### 12.4 Vérifier SMB Client (REQUIS pour PrintNightmare!)

```powershell
# SMB Services doivent être Running
Get-Service LanmanWorkstation, LanmanServer | Select-Object Name, Status

# Test SMB outbound vers VM1 (attacker share)
Test-NetConnection -ComputerName 10.0.0.45 -Port 445
# Doit être: TcpTestSucceeded = True
```

### 12.5 Vérifier scada_user peut écrire dans C:\Windows\Temp

```powershell
# Test avec scada_user (requis pour payload DLL)
"TEST" | Out-File "C:\Windows\Temp\test.txt"
Remove-Item "C:\Windows\Temp\test.txt"
# Doit réussir sans erreur
```

---

## 📊 ÉTAPE 13 : DONNÉES POUR EXFILTRATION (~30-50 MB)

> ℹ️ Ces données factices simulent des informations sensibles d'un laboratoire biomédical.

```powershell
# Créer structure
New-Item -Path "C:\SCADA\Data\Patients" -ItemType Directory -Force
New-Item -Path "C:\SCADA\Data\Research" -ItemType Directory -Force
New-Item -Path "C:\SCADA\Data\Formulas" -ItemType Directory -Force
New-Item -Path "C:\SCADA\Data\Calibration" -ItemType Directory -Force

# Générer fichiers patients (~15 MB)
Write-Host "Génération des fichiers patients..." -ForegroundColor Yellow
1..500 | ForEach-Object {
    $content = "CONFIDENTIEL - DOSSIER PATIENT`n"
    $content += "Patient ID: PAT-$_`n"
    $content += "Date: $(Get-Date)`n"
    $content += "Données médicales:`n"
    $content += (1..3000 | ForEach-Object { "Mesure $_`: $((Get-Random -Maximum 9999)/100)" }) -join "`n"
    $content | Out-File "C:\SCADA\Data\Patients\patient_$_.dat" -Encoding UTF8
}

# Générer fichiers recherche (~15 MB)
Write-Host "Génération des fichiers recherche..." -ForegroundColor Yellow
1..200 | ForEach-Object {
    $content = "PROPRIÉTAIRE - PROTOCOLE RECHERCHE`n"
    $content += "Protocole: PROTO-$_`n"
    $content += (1..5000 | ForEach-Object { "Séquence $_`: $([guid]::NewGuid().ToString())" }) -join "`n"
    $content | Out-File "C:\SCADA\Data\Research\protocol_$_.dat" -Encoding UTF8
}

# Générer fichiers formules (~10 MB)
Write-Host "Génération des fichiers formules..." -ForegroundColor Yellow
1..100 | ForEach-Object {
    $content = "SECRET INDUSTRIEL - FORMULE PROPRIÉTAIRE`n"
    $content += "Formule: FORM-$_`n"
    $content += (1..3000 | ForEach-Object { "Composant $_`: $(Get-Random -Maximum 999)mg" }) -join "`n"
    $content | Out-File "C:\SCADA\Data\Formulas\formula_$_.dat" -Encoding UTF8
}

# Générer fichiers calibration (~5 MB)
Write-Host "Génération des fichiers calibration..." -ForegroundColor Yellow
1..50 | ForEach-Object {
    $content = "DONNÉES CALIBRATION ÉQUIPEMENT`n"
    $content += "Équipement: EQ-$_`n"
    $content += (1..3000 | ForEach-Object { "Point $_`: $((Get-Random -Maximum 99999)/1000)" }) -join "`n"
    $content | Out-File "C:\SCADA\Data\Calibration\calib_$_.dat" -Encoding UTF8
}

# Vérifier taille totale
Write-Host "`nVérification taille:" -ForegroundColor Green
Get-ChildItem C:\SCADA\ -Recurse | Measure-Object -Property Length -Sum | 
    Select-Object Count, @{N='SizeMB';E={[math]::Round($_.Sum/1MB,2)}}
```

**Résultat attendu:** ~45-50 MB de données

---

## ✅ ÉTAPE 14 : VÉRIFICATION FINALE

```powershell
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "         VM2 VERIFICATION - PROJET P14" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan

Write-Host "`n[1] INFOS DE BASE" -ForegroundColor Yellow
Write-Host "Hostname: $(hostname)"
Write-Host "IP: $((Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -like '10.0.0.*'}).IPAddress)"

Write-Host "`n[2] COMPTES" -ForegroundColor Yellow
Write-Host "scada_user dans RDP Users:"
net localgroup "Utilisateurs du Bureau à distance" | findstr "scada"
Write-Host "scada_admin dans Admins:"
net localgroup "Administrateurs" | findstr "scada"

Write-Host "`n[3] SERVICE SCADA_API" -ForegroundColor Yellow
Get-Service SCADA_API | Select-Object Name, Status, StartType
Test-Path "C:\SCADA\HMI\api\scada_api.exe"

Write-Host "`n[4] PRINT SPOOLER (PrintNightmare)" -ForegroundColor Yellow
Get-Service Spooler | Select-Object Name, Status, StartType
$patch = Get-HotFix | Where-Object {$_.HotFixID -match "KB5004945|KB5004946|KB5004947|KB5004948"}
if ($patch) { Write-Host "PATCHED - NON EXPLOITABLE!" -ForegroundColor Red } else { Write-Host "No patch - Exploitable" -ForegroundColor Green }

Write-Host "`n[5] SMB SERVICES (requis PrintNightmare)" -ForegroundColor Yellow
Get-Service LanmanWorkstation, LanmanServer | Select-Object Name, Status

Write-Host "`n[6] SMB OUTBOUND vers VM1" -ForegroundColor Yellow
$smb = Test-NetConnection -ComputerName 10.0.0.45 -Port 445 -WarningAction SilentlyContinue
Write-Host "SMB to VM1 (10.0.0.45:445): $($smb.TcpTestSucceeded)"

Write-Host "`n[7] RÈGLES PARE-FEU P14" -ForegroundColor Yellow
Get-NetFirewallRule -DisplayName "P14*" | Select-Object DisplayName, Enabled, Direction, Action | Format-Table -AutoSize

Write-Host "`n[8] TEST API" -ForegroundColor Yellow
try { 
    $r = Invoke-RestMethod -Uri "http://localhost:5000/api/plc/all" -TimeoutSec 5
    Write-Host "API Status: $($r.overall_status)" -ForegroundColor Green
} catch { Write-Host "API FAILED!" -ForegroundColor Red }

Write-Host "`n[9] CONNECTIVITÉ PLC (via API)" -ForegroundColor Yellow
# Note: Test direct bloqué par firewall, vérifier via API
try {
    $api = Invoke-RestMethod -Uri "http://localhost:5000/api/plc/all" -TimeoutSec 5
    $plc1 = ($api.plcs | Where-Object {$_.id -eq 1}).status
    $plc2 = ($api.plcs | Where-Object {$_.id -eq 2}).status
    Write-Host "PLC1 INCUBATEUR: $plc1" -ForegroundColor $(if($plc1 -eq "NORMAL"){"Green"}else{"Red"})
    Write-Host "PLC2 CENTRIFUGEUSE: $plc2" -ForegroundColor $(if($plc2 -eq "NORMAL"){"Green"}else{"Red"})
} catch {
    Write-Host "Impossible de vérifier PLCs via API" -ForegroundColor Red
}

Write-Host "`n[10] DONNÉES SCADA" -ForegroundColor Yellow
$d = Get-ChildItem C:\SCADA\ -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum
Write-Host "Fichiers: $($d.Count), Taille: $([math]::Round($d.Sum/1MB,2)) MB"

Write-Host "`n[11] PERMISSIONS PYTHON" -ForegroundColor Yellow
$pyPerm = icacls "C:\Program Files\Python312\python.exe" 2>&1
if ($pyPerm -match "Utilisateurs.*\(R\)") { 
    Write-Host "Python: Read-only pour Users (OK)" -ForegroundColor Green 
} else { 
    Write-Host "Python: VÉRIFIER PERMISSIONS!" -ForegroundColor Red 
}

Write-Host "`n[12] PERMISSIONS CURL" -ForegroundColor Yellow
$curlPerm = icacls "C:\Windows\System32\curl.exe" 2>&1
if ($curlPerm -match "Utilisateurs.*\(R\)") { 
    Write-Host "Curl: Read-only pour Users (OK)" -ForegroundColor Green 
} else { 
    Write-Host "Curl: VÉRIFIER PERMISSIONS!" -ForegroundColor Red 
}

Write-Host "`n═══════════════════════════════════════════════════════" -ForegroundColor Cyan
```

---

## 🧪 TESTS DE SÉCURITÉ (avec scada_user)

> ⚠️ Se connecter en tant que **scada_user** pour ces tests!

```powershell
# Test 1: Python bloqué
python --version
# Attendu: "Accès refusé" ou "n'a pas pu s'exécuter"

# Test 2: Copy Python bypass bloqué
copy "C:\Program Files\Python312\python.exe" "C:\Users\scada_user\py.exe"
C:\Users\scada_user\py.exe --version
# Attendu: Exit code -1073741790 (ACCESS_DENIED) - pas d'output

# Test 3: Curl bloqué
curl.exe --version
# Attendu: "Accès refusé"

# Test 4: PowerShell TCP vers Modbus bloqué
$c = New-Object System.Net.Sockets.TcpClient
$c.Connect("10.0.0.80", 502)
# Attendu: "Une tentative d'accès à un socket de manière interdite"

# Test 5: certutil bloqué
certutil -urlcache -split -f "http://example.com/test.txt" "C:\Users\scada_user\test.txt"
# Attendu: "Accès refusé"

# Test 6: API accessible (lecture seule)
Invoke-RestMethod -Uri "http://localhost:5000/api/plc/all"
# Attendu: Données PLC avec status NORMAL

# Test 7: API POST bloqué (pas de write)
Invoke-RestMethod -Uri "http://localhost:5000/api/plc/1" -Method POST -Body '{"value":650}'
# Attendu: 405 Method Not Allowed

# Test 8: SMB outbound fonctionne (pour PrintNightmare)
Test-NetConnection -ComputerName 10.0.0.45 -Port 445
# Attendu: TcpTestSucceeded = True

# Test 9: Écriture dans C:\Windows\Temp (pour payload DLL)
"TEST" | Out-File "C:\Windows\Temp\test_scada.txt"
Remove-Item "C:\Windows\Temp\test_scada.txt"
# Attendu: Succès (pas d'erreur)
```

### Résumé des résultats attendus

| Test | Résultat attendu | Raison |
|------|------------------|--------|
| Python | ❌ Bloqué | NTFS permissions |
| Python copy | ❌ Bloqué | Dependencies inaccessibles |
| Curl | ❌ Bloqué | NTFS permissions |
| PowerShell TCP | ❌ Bloqué | Firewall P14-Block-Modbus-PowerShell |
| certutil | ❌ Bloqué | Restrictions Windows |
| API GET | ✅ Fonctionne | Lecture seule autorisée |
| API POST | ❌ Bloqué | Pas d'endpoint write |
| SMB outbound | ✅ Fonctionne | Requis pour PrintNightmare |
| C:\Windows\Temp | ✅ Fonctionne | Requis pour payload DLL |

---

## 🎯 RÔLE DANS LE SCÉNARIO P14

| Phase | Action sur VM2 |
|-------|----------------|
| **Phase 3** | Attaquant RDP avec scada_user (depuis VM1) |
| **Phase 4** | Reconnaissance: découvre PLCs, Python bloqué |
| **Phase 5** | PrintNightmare → SYSTEM |
| **Phase 6** | Sabotage PLCs via Modbus |
| **Phase 7** | Exfiltration données C:\SCADA\ |

---

## 📋 RÉSUMÉ DES FICHIERS REQUIS

| Fichier | Emplacement | Source |
|---------|-------------|--------|
| scada_api.py | C:\SCADA\HMI\api\ | Fourni par l'utilisateur |
| index.html | C:\SCADA\HMI\web\ → C:\inetpub\wwwroot\ | Fourni par l'utilisateur |
| nssm.exe | C:\Windows\System32\ | Téléchargé (nssm.cc) |
| scada_api.exe | C:\SCADA\HMI\api\ | Compilé avec PyInstaller |

---

## ⚠️ NOTES IMPORTANTES

### Ordre des règles pare-feu

Les règles **Allow** doivent être créées AVANT les règles **Block** pour que `scada_api.exe` puisse communiquer avec les PLCs.

### Windows Defender

Windows Defender est **activé par défaut**. Pour le scénario:
- **Ne pas désactiver** - Cela rend le scénario plus réaliste
- L'attaquant devra le contourner après PrintNightmare

### Vérification service SCADA_API

Si le service ne démarre pas, vérifier:
```powershell
# Logs d'erreur
Get-Content "C:\SCADA\HMI\logs\api_stderr.log"

# Test manuel
C:\SCADA\HMI\api\scada_api.exe
```

### PLCs (VM5/VM6) doivent être démarrés

Le service SCADA_API nécessite que les PLCs soient accessibles:
- VM5 (10.0.0.80:502) - INCUBATEUR
- VM6 (10.0.0.59:502) - CENTRIFUGEUSE

---

## 🔧 DÉPANNAGE

| Problème | Solution |
|----------|----------|
| Service SCADA_API ne démarre pas | Vérifier logs dans C:\SCADA\HMI\logs\ |
| API retourne erreur | Vérifier que VM5/VM6 sont démarrés |
| Python "Accès refusé" ne fonctionne pas | Vérifier icacls permissions |
| PrintNightmare échoue | Vérifier SMB outbound vers VM1 |
| RDP impossible depuis VM1 | Vérifier firewall rule P14-Allow-Maintenance-VM1 |
