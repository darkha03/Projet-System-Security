# 🖥️ P14 - GUIDE CONFIGURATION VM1 (POSTE-IT)

## 📋 INFORMATIONS

| Paramètre | Valeur |
|-----------|--------|
| **Hostname** | P14-Poste-IT |
| **IP** | 10.0.0.45/24 |
| **Gateway** | 10.0.0.254 |
| **DNS** | 8.8.8.8 |
| **OS** | Windows 10/11 Pro (Français) |
| **Rôle** | Poste IT - Cible phishing (Patient Zero) |

---

## 🔧 ÉTAPE 1 : CONFIGURATION RÉSEAU

```powershell
# Configurer IP statique
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 10.0.0.45 -PrefixLength 24 -DefaultGateway 10.0.0.254

# Configurer DNS
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "8.8.8.8","8.8.4.4"

# Renommer l'ordinateur (redémarrage requis)
Rename-Computer -NewName "P14-Poste-IT" -Force
```

---

## 👤 ÉTAPE 2 : COMPTES UTILISATEURS

```powershell
# Créer compte technicien (utilisateur standard - cible phishing)
net user technicien Tech2024! /add
net localgroup Utilisateurs technicien /add

# Créer compte it.admin (administrateur IT)
net user it.admin ITAdmin2024! /add
net localgroup Administrateurs it.admin /add
```

### Comptes finaux

| Compte | Mot de passe | Groupe | Rôle |
|--------|--------------|--------|------|
| technicien | Tech2024! | Utilisateurs | ⭐ Cible phishing |
| it.admin | ITAdmin2024! | Administrateurs | Admin IT |
| Administrateur | (système) | Administrateurs | Admin Windows |

---

## 🔓 ÉTAPE 3 : DÉSACTIVER LES PROTECTIONS

```powershell
# Désactiver Windows Defender (temps réel)
Set-MpPreference -DisableRealtimeMonitoring $true

# Désactiver UAC
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0

# Désactiver pare-feu (tous les profils)
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Autoriser scripts PowerShell
Set-ExecutionPolicy Unrestricted -Force
```

---

## 🔑 ÉTAPE 4 : ENREGISTRER CREDENTIALS SCADA

**⚠️ IMPORTANT : Effectuer cette étape en tant qu'utilisateur `technicien`**

### Option A : Via interface graphique (recommandé)

1. Se connecter en tant que `technicien`
2. Ouvrir **Connexion Bureau à distance** (`Win+R` → `mstsc`)
3. Ordinateur : `10.0.0.10`
4. Cliquer **Afficher les options**
5. Nom d'utilisateur : `scada_user`
6. ☑️ Cocher **M'autoriser à enregistrer les informations d'identification**
7. Cliquer **Connexion**
8. Mot de passe : `Secure2024@!`
9. Quand demandé "Enregistrer les informations ?" → **Oui**
10. Après connexion réussie → Fermer la session

### Option B : Via ligne de commande

```powershell
# Exécuter en tant que technicien
cmdkey /generic:"TERMSRV/10.0.0.10" /user:"scada_user" /pass:"Secure2024@!"
```

---

## ✅ ÉTAPE 5 : VÉRIFICATION

```powershell
# Vérifier hostname et IP
hostname
ipconfig | findstr "IPv4"

# Vérifier comptes
net user

# Vérifier Defender désactivé
(Get-MpComputerStatus).RealTimeProtectionEnabled

# Vérifier UAC désactivé
(Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).EnableLUA

# Vérifier pare-feu désactivé
Get-NetFirewallProfile | Select-Object Name, Enabled

# Vérifier credentials (en tant que technicien)
cmdkey /list

# Vérifier connectivité vers VM2
Test-NetConnection -ComputerName 10.0.0.10 -Port 3389
```

### Résultats attendus

| Vérification | Résultat attendu |
|--------------|------------------|
| Hostname | P14-Poste-IT |
| IP | 10.0.0.45 |
| Defender | False |
| UAC | 0 |
| Pare-feu | False (tous) |
| Credentials | TERMSRV/10.0.0.10 + scada_user |
| RDP vers VM2 | TcpTestSucceeded: True |

---

## 📜 SCRIPT COMPLET (Exécuter en tant qu'Administrateur)

```powershell
#═══════════════════════════════════════════════════════════════
# P14 - CONFIGURATION VM1 (POSTE-IT)
# Exécuter en tant qu'Administrateur
#═══════════════════════════════════════════════════════════════

Write-Host "=== CONFIGURATION VM1 - P14 ===" -ForegroundColor Cyan

# 1. Réseau
Write-Host "[1/4] Configuration réseau..." -ForegroundColor Yellow
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 10.0.0.45 -PrefixLength 24 -DefaultGateway 10.0.0.254 -ErrorAction SilentlyContinue
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "8.8.8.8","8.8.4.4"
Rename-Computer -NewName "P14-Poste-IT" -Force -ErrorAction SilentlyContinue

# 2. Comptes
Write-Host "[2/4] Création des comptes..." -ForegroundColor Yellow
net user technicien Tech2024! /add 2>$null
net localgroup Utilisateurs technicien /add 2>$null
net user it.admin ITAdmin2024! /add 2>$null
net localgroup Administrateurs it.admin /add 2>$null

# 3. Désactiver protections
Write-Host "[3/4] Désactivation des protections..." -ForegroundColor Yellow
Set-MpPreference -DisableRealtimeMonitoring $true
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Set-ExecutionPolicy Unrestricted -Force

# 4. Vérification
Write-Host "[4/4] Vérification..." -ForegroundColor Yellow
Write-Host "Hostname: $(hostname)" -ForegroundColor White
Write-Host "IP: $((Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -like '10.0.0.*'}).IPAddress)" -ForegroundColor White
Write-Host "Defender: $((Get-MpComputerStatus).RealTimeProtectionEnabled)" -ForegroundColor White
Write-Host "RDP VM2: $((Test-NetConnection 10.0.0.10 -Port 3389 -WarningAction SilentlyContinue).TcpTestSucceeded)" -ForegroundColor White

Write-Host "`n=== CONFIGURATION TERMINÉE ===" -ForegroundColor Green
Write-Host "⚠️  Redémarrer puis configurer credentials avec utilisateur 'technicien'" -ForegroundColor Yellow
```

---

## ⚠️ RAPPEL POST-REDÉMARRAGE

Après redémarrage, se connecter en tant que **technicien** et exécuter :

```powershell
cmdkey /generic:"TERMSRV/10.0.0.10" /user:"scada_user" /pass:"Secure2024@!"
cmdkey /list
```

---

## 🎯 RÔLE DANS LE SCÉNARIO P14

| Étape | Action |
|-------|--------|
| **Étape 1** | technicien reçoit email phishing → VM1 compromise |
| **Étape 2** | Attaquant exécute `cmdkey /list` → Découvre credentials SCADA |
| **Étape 3** | Attaquant utilise credentials → RDP vers VM2 (mouvement latéral) |
