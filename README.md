# Project System Security - OT/ICS Crisis Management Lab

**Automated Cyber Crisis Simulation | Infrastructure as Code | OT/SCADA Attack Scenario**

This repository contains the complete **Infrastructure as Code (IaC)** configuration to deploy a fully automated Cyber Crisis Management Range using **Ludus**. It provisions an OpenBAS Attack Simulation controller, SCADA/HMI server, simulated PLCs, and IT workstations pre-configured with a **150-minute multi-team crisis scenario** targeting critical infrastructure (IoT/OT/ICS).

## 🎯 Scenario Overview

**Operation: Lab Sabotage**  
- **Duration:** 90 minutes  
- **Teams:** 3 (Techniciens Biomedicals, IT Security Team, Responsable Lab)  
- **Objective:** Manage a multi-faceted cybersecurity crisis in real-time involving ICS/SCADA compromise, data exfiltration, and operational sabotage  
- **Attack Chain:** 10 progressive stages from initial phishing to full OT environment compromise

## 🏗️ Architecture

The lab consists of five Virtual Machines deployed on Proxmox via Ludus:

| Role | Hostname | IP Address | OS | Function |
| :--- | :--- | :--- | :--- | :--- |
| **Controller** | `openbas-controller` | `10.0.0.23` | Debian 11 | Runs OpenBAS (Docker), PostgreSQL, MinIO, and SOC monitoring dashboard (Python HTTP) |
| **IT Workstation** | `P14-Poste-IT` | `10.0.0.45` | Windows Server 2022 | Initial compromise target (Patient Zero) |
| **SCADA Server** | `P14-SCADA-OT` | `10.0.0.10` | Windows Server 2022 | SCADA HMI web interface with Flask API for Modbus communication |
| **PLC - Incubator** | `PLC1` | `10.x.x.80` | Debian 11 | Modbus TCP simulator (Temperature control) |
| **PLC - Centrifuge** | `PLC2` | `10.x.x.59` | Debian 11 | Modbus TCP simulator (Speed control) |

---

## 📂 Repository Structure

```text
Projet-System-Security/
├── README.md                       # This file
├── Guide.md                        # Deployment and scenario guide
├── openbas-server/                 # OpenBAS Installation (Standalone)
│   ├── docker/                     # Docker configuration for OpenBAS
│   │   ├── docker-compose.yml      # OpenBAS container stack
│   │   ├── .env.exemple            # Environment variables template
│   │   ├── init_lab.sql            # Pre-loaded crisis scenario database
│   │   └── rabbitmq.conf           # RabbitMQ configuration
│   └── html/                       # SOC Monitoring Dashboard
│       ├── p14-dashboard.html      # Security monitoring dashboard
│       └── p14-alerts.json         # Alert definitions and thresholds
└── ludus/                          # Infrastructure Deployment (IaC)
    ├── config.yml                  # Main Ludus Range configuration (5 VMs)
    └── roles/
        ├── openbas-server/         # OpenBAS Controller role
        │   └── tasks/main.yml      # Ansible tasks: Docker, DB, Python HTTP server
        ├── p14-vm1/                # IT Workstation (Patient Zero)
        │   └── tasks/main.yml      # Windows setup + OpenBAS agent
        ├── p14-vm2/                # SCADA Backend Server
        │   ├── tasks/main.yml      # IIS + Python Flask API setup
        │   └── files/
        │       └── scada_api.py    # Flask API for Modbus PLC communication
        └── p14-plc/                # Simulated PLCs (Modbus TCP)
            └── tasks/main.yml      # Deploys pyModbusTCP server instances
```

## 🚀 Getting Started

**Prerequisites**

- A running Ludus instance
- Proxmox templates for Debian 11, Windows Server 2022
- Minimum 20GB RAM available across VMs
- Python 3 (for SCADA HMI web server)

**Deployment Guide**

The deployment is now separated into two phases:

### **Phase 1: OpenBAS Server Setup (Manual)**

**1. Clone this repository:**
```bash
git clone https://github.com/darkha03/Projet-System-Security.git
cd Projet-System-Security
```

**2. Configure OpenBAS environment:**
```bash
cd openbas-server/docker
cp .env.exemple .env
nano .env
```

Update critical settings:
- `OPENBAS_ADMIN_EMAIL` (default: admin@openbas.io)
- `OPENBAS_ADMIN_PASSWORD` (set a strong password)
- `OPENBAS_ADMIN_TOKEN` (must match agent tokens in ludus/config.yml)

**3. Deploy OpenBAS with Docker:**

```bash
docker-compose up -d
```

⚠️ Important : En cas de problème lors de la création des injects pour le scénario, veuillez importer directement les injects depuis le dossier "Data for injects" (par précaution) dans OpenBAS afin de pouvoir démarrer le scénario.

**4. Start the SOC monitoring dashboard:**
```bash
cd ../html
python3 -m http.server 8000
```

The SOC dashboard will be available at `http://10.0.0.23:8000/p14-dashboard.html`

### **Phase 2: Infrastructure Deployment (Ludus)**

**5. Navigate to the Ludus configuration:**
```bash
cd ../../ludus
```

**6. Add the roles to Ludus:**
```bash
ludus ansible role add -d roles/p14-vm1
ludus ansible role add -d roles/p14-vm2
ludus ansible role add -d roles/p14-plc
```

This will make the custom roles available for the range deployment.

**7. Set the configuration as default:**
```bash
ludus range config set --file config.yml
```

**8. Verify configuration matches your OpenBAS setup:**
```bash
nano config.yml
```

Ensure `agent_token` matches your `.env` file from Phase 1.

**9. Deploy the infrastructure:**
```bash
ludus range deploy
```

**10. Wait for Provisioning**: 

Ludus will:
- Spin up 4 VMs (1 IT workstation + 1 SCADA backend + 2 PLCs)
- Configure SCADA Flask API and IIS on Windows
- Start Modbus TCP servers on both PLC simulators
- Install OpenBAS agents on Windows machines

> ⏱️ **Time Estimation:** ~2 hours on a Ludus host with 32GB RAM and 16 CPU cores.

### ⚠️ Troubleshooting Deployment Issues

| Error | Solution |
|-------|----------|
| `Connection timeout` / Cannot reach IP | Redeploy the range: `ludus range deploy` |
| Errors occurring after VM 2/3/4 provisioning | Remove the successfully deployed VMs from config.yml, redeploy remaining VMs|

> **⚠️ Template Warning:** If your Proxmox templates differ from those specified in `config.yml` (e.g., different names or OS versions), the provisioning may behave differently or fail. Ensure template names match exactly.

## 💻 Access & Usage

**1. Access the OpenBAS Dashboard**

Open your browser and navigate to:

- **URL:** http://10.0.0.23:8080
- **Email:** admin@openbas.io (or your configured value)
- **Password:** Check your `.env` file

**2. Access the SOC Monitoring Dashboard**

The security monitoring dashboard is hosted on the OpenBAS controller:

- **URL:** http://10.0.0.23:8000/p14-dashboard.html
- **Function:** Real-time security alerts and incident tracking for the crisis simulation
- **How to access:** Open a browser from any machine on the network and navigate to the URL above

**3. Connect to IT Workstation (P14-Poste-IT)**

Access the Windows IT workstation (Patient Zero):

| Method | Details |
|--------|---------|
| **RDP** | `mstsc /v:10.0.0.45` or use Remote Desktop to `10.0.0.45` |
| **Ludus Console** | `ludus range access P14-Poste-IT` |
| **Credentials** | Use the default Ludus Windows credentials (check Ludus documentation) |

**4. Connect to OT SCADA Server (P14-SCADA-OT)**

Access the Windows SCADA/HMI server:

| Method | Details |
|--------|---------|
| **RDP** | `mstsc /v:10.0.0.10` or use Remote Desktop to `10.0.0.10` |
| **Ludus Console** | `ludus range access P14-SCADA-OT` |
| **SCADA HMI Web** | http://10.0.0.10 (from browser) |
| **SCADA API** | http://10.0.0.10:5000/api/plc/{1\|2} |
| **Credentials** | Use the default Ludus Windows credentials |

**5. Verify Agents**

Go to **Assets > Endpoints** in OpenBAS. You should see two active endpoints:

- 🟢 P14-Poste-IT (Windows IT workstation) has one agents: technicien (session)
- 🟢 P14-SCADA-OT (Windows SCADA server) has two agents: scada_user (service user) and system 

**6. Verify PLCs**

Test Modbus connectivity from the SCADA server:
```bash
# From P14-SCADA-OT, the Flask API should be running on port 5000
curl http://localhost:5000/api/plc/1  # Incubator (10.0.0.80:502)
curl http://localhost:5000/api/plc/2  # Centrifuge (10.0.0.59:502)
```

**7. Launch the Crisis Simulation**

1. Navigate to **Simulations** in OpenBAS
2. Open **"Operation: Lab Sabotage"** or your pre-configured scenario
3. Click **Start** to begin the  attack chain

**7. Rétablir l’état initial pour relancer la simulation si nécessaire**
Sur le serveur SCADA OT, veuillez exécuter les commandes suivantes :

```powershell
net localgroup Administrateurs scada_user /delete
net user scada_adm1n /delete
rm -recurse C:\Users\scada_adm1n -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1 -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 5 -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Value 1 -Force
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | Select-Object EnableLUA,ConsentPromptBehaviorAdmin,PromptOnSecureDesktop
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" -Name "scada_adm1n" -ErrorAction SilentlyContinue -Force
Set-NetFirewallRule -DisplayName "P14-Block-Modbus-PowerShell" -Enabled True
Set-NetFirewallRule -DisplayName "P14-Block-Modbus-Python" -Enabled True
Set-NetFirewallRule -DisplayName "P14-Block-Modbus-CMD" -Enabled True
```

---

## 🎭 Crisis Scenario Phases

The attack simulation follows a realistic 9-phase kill chain inspired by the **Colonial Pipeline (2021)** incident, orchestrated via **OpenBAS** with 28 automated injects:

| Phase | Time | Name | Injects | Description |
|:-----:|:----:|------|:-------:|-------------|
| **1** | T+0→T+2 | **Initial Access** | 2 | Spear phishing email with macro-enabled attachment targeting lab technician. Payload establishes initial foothold on IT workstation (VM1). |
| **2** | T+5→T+8 | **Discovery & Credential Harvesting** | 3 | Attacker enumerates system context, discovers saved RDP credentials (`cmdkey /list`), and identifies SCADA server as target. |
| **3** | T+10→T+14 | **Lateral Movement IT→OT** | 4 | RDP connection from VM1 to SCADA server using harvested credentials. Verify user privileges and test initial Modbus access (blocked). |
| **4** | T+15→T+17 | **OT Reconnaissance** | 3 | Service enumeration, vulnerability assessment, and system architecture mapping. Identifies Print Spooler as attack vector. |
| **5** | T+19→T+33 | **Privilege Escalation** | 5 | Exploit **PrintNightmare (CVE-2021-34527)**: verify spooler status, drop DLL payload, execute exploit, verify SYSTEM privileges obtained. |
| **6** | T+37→T+59 | **Firewall Bypass** | 5 | Enumerate firewall rules, identify Modbus blocks, disable all blocking rules, verify Modbus TCP access to PLCs is now possible. |
| **7** | T+63→T+73 | **PLC Sabotage** | 2 | Read current PLC states, then execute coordinated sabotage: Incubator (37°C→65°C), Centrifuge (3000→9999 RPM). |
| **8** | T+75→T+81 | **Data Exfiltration** | 3 | Enumerate sensitive data in C:\SCADA\, compress ~45MB archive, exfiltrate via HTTP. |
| **9** | T+87 | **Cover Tracks** | 1 | Clear Windows Event Logs (Security, System, Application) and PowerShell history to hinder forensics. |

### Detailed Inject Timeline (OpenBAS)

```
T+01m  ─── 1. Download-Macro-Enabled-Phishing-Attachment
T+02m  ─── 2. Phase1-Initial-Foothold
T+05m  ─── 3. Phase2-Context-Enumeration
T+08m  ─┬─ 4. Phase2-Credential-Harvesting
        └─ 5. Phase2-Target-Identification
T+10m  ─── 6. Phase3-Verify-Lateral-Movement
T+12m  ─── 7. Phase3-Verify-User-Privileges
T+13m  ─── 8. Phase3-Network-Reconnaissance
T+14m  ─── 9. Phase3-Test-Modbus-Access
T+15m  ─── 10. Phase4-Service-Enumeration
T+16m  ─── 11. Phase4-Vulnerability-Assessment
T+17m  ─── 12. Phase4-System-Architecture
T+19m  ─── 13. Phase5-Verify-Print-Spooler
T+22m  ─── 14. Phase5-Drop-Nightmare-DLL
T+25m  ─── 15. Phase5-Drop-Exploit-Script
T+28m  ─── 16. Phase5-Execute-PrintNightmare
T+33m  ─── 17. Phase5-Verify-Privilege-Escalation
T+37m  ─── 18. Phase6-Enumerate-Firewall-Rules
T+42m  ─── 19. Phase6-Inspect-All-Block-Rules
T+50m  ─── 20. Phase6-Test-Modbus-Access-Blocked
T+55m  ─── 21. Phase6-Disable-All-Modbus-Block-Rules
T+59m  ─── 22. Phase6-Verify-Modbus-Access
T+63m  ─── 23. Phase7-Read-PLC-Current-State
T+73m  ─── 24. Phase7-Coordinated-Sabotage-Both-PLCs
T+75m  ─── 25. Phase8-Enumerate-Sensitive-Data
T+78m  ─── 26. Phase8-Compress-Sensitive-Data
T+81m  ─── 27. Phase8-Exfiltrate-Data-HTTP
T+87m  ─── 28. Phase9-Complete-Cover-Tracks
```

---

## 🛡️ Team Roles

| Team | Primary Responsibilities | Key Decisions |
|------|-------------------------|---------------|
| **Techniciens Biomedicals** | PLC/OT system expertise, equipment calibration, sample preservation | Technical remediation strategies, triage priorities during sabotage |
| **IT Security Team** | Network defense, incident response, forensics | Isolation decisions, system recovery, attack mitigation |
| **Responsable Lab** | Overall crisis coordination, equipment safety, regulatory compliance | Risk assessment, escalation protocols, emergency stop decisions |

---

## 🔧 Technical Components

### **SOC Monitoring Dashboard (Python HTTP Server)**
- Hosted on OpenBAS controller (10.0.0.23:8000)
- Real-time security alerts and incident tracking
- Crisis simulation status visualization
- Served via Python's built-in HTTP server

### **SCADA HMI & Backend API**
- **HMI Interface:** Hosted on P14-SCADA-OT (10.0.0.10)
- **Flask API:** Runs on P14-SCADA-OT Windows server (10.0.0.10:5000)
- Real-time PLC data polling via Modbus TCP
- REST API endpoints for HMI dashboard
- Status classification: NORMAL / WARNING / CRITICAL

### **Simulated PLCs (pyModbusTCP)**
- **PLC1 (Incubator):** Holding registers for temperature, humidity, status, alarms
- **PLC2 (Centrifuge):** Holding registers for speed, vibration, temperature, alarms
- Modbus function code 0x03 (Read Holding Registers)

### **Attack Vectors**
- Credential theft (phishing)
- Default PLC passwords (industrial hygiene failure)
- IT/OT network bridging exploitation
- CVE-based privilege escalation
- Anti-forensics and persistence mechanisms

---

## 📊 Learning Objectives

✅ **Cross-team coordination** under time pressure  
✅ **IT/OT convergence** security challenges  
✅ **Incident response** decision-making with incomplete information  
✅ **Regulatory compliance** (GDPR, critical infrastructure directives)  
✅ **Forensics preservation** during active attacks  
✅ **Business continuity** vs. security trade-offs  

---

## 📝 Post-Exercise Debrief

After the 150-minute simulation, conduct a structured After-Action Review:

1. **Timeline reconstruction** (what happened when)
2. **Decision analysis** (what worked, what failed)
3. **Team communication effectiveness**
4. **Technical gaps identified**
5. **Process improvements for real incidents**

---

## 🤝 Contributing

Contributions are welcome! Areas for enhancement:
- Additional attack stages or injects
- More realistic PLC simulations (ladder logic)
- Integration with real SIEM/IDS tools
- Multi-site crisis scenarios

---

## 📄 License

This project is for **educational and training purposes only**. Do not use these techniques on systems you do not own or have explicit permission to test.

---

## 🔗 References

- [Ludus Documentation](https://docs.ludus.cloud/)
- [OpenBAS Platform](https://www.openbas.io/)
- [MITRE ATT&CK for ICS](https://attack.mitre.org/tactics/ics/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

