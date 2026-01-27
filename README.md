# Project System Security - OT/ICS Crisis Management Lab

**Automated Cyber Crisis Simulation | Infrastructure as Code | OT/SCADA Attack Scenario**

This repository contains the complete **Infrastructure as Code (IaC)** configuration to deploy a fully automated Cyber Crisis Management Range using **Ludus**. It provisions an OpenBAS Attack Simulation controller, SCADA/HMI server, simulated PLCs, and IT workstations pre-configured with a **150-minute multi-team crisis scenario** targeting critical infrastructure (IoT/OT/ICS).

## 🎯 Scenario Overview

**Operation: Lab Sabotage**  
- **Duration:** 150 minutes  
- **Teams:** 7 (Lab Operations, Biomedical Engineering, IT, CISO, DPO, Legal, Communications)  
- **Objective:** Manage a multi-faceted cybersecurity crisis in real-time involving ICS/SCADA compromise, data exfiltration, and operational sabotage  
- **Attack Chain:** 10 progressive stages from initial phishing to full OT environment compromise

## 🏗️ Architecture

The lab consists of five Virtual Machines deployed on Proxmox via Ludus:

| Role | Hostname | IP Address | OS | Function |
| :--- | :--- | :--- | :--- | :--- |
| **Controller** | `openbas-controller` | `10.0.0.5` | Debian 11 | Runs OpenBAS (Docker), PostgreSQL, MinIO, and SCADA HMI web server (Python HTTP) |
| **IT Workstation** | `P14-Poste-IT` | `10.0.0.45` | Windows Server 2022 | Initial compromise target (Patient Zero) |
| **SCADA Server** | `P14-SCADA-OT` | `10.0.0.10` | Windows Server 2022 | SCADA backend with Flask API for Modbus communication |
| **PLC - Incubator** | `PLC1` | `10.0.0.80` | Debian 11 | Modbus TCP simulator (Temperature control) |
| **PLC - Centrifuge** | `PLC2` | `10.0.0.59` | Debian 11 | Modbus TCP simulator (Speed control) |

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
│   └── html/                       # SCADA HMI Web Interface
│       ├── p14-dashboard.html      # Real-time monitoring dashboard
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

**4. Start the SCADA HMI web server:**
```bash
cd ../html
python3 -m http.server 8000
```

The SCADA dashboard will be available at `http://10.0.0.5:8000/p14-dashboard.html`

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

**Provisioning typically takes 15-20 minutes.**

## 💻 Access & Usage

**1. Access the OpenBAS Dashboard**

Open your browser and navigate to:

- **URL:** http://10.0.0.5:8080
- **Email:** admin@openbas.io (or your configured value)
- **Password:** Check your `.env` file

**2. Access the SCADA HMI**

The SCADA supervisory dashboard is now hosted on the OpenBAS controller:

- **URL:** http://10.0.0.5:8000/p14-dashboard.html
- **Function:** Real-time monitoring of both PLCs (Incubator & Centrifuge)
- **Backend API:** http://10.0.0.10:5000/api/plc/{1|2} (Flask on P14-SCADA-OT)

**3. Verify Agents**

Go to **Assets > Agents** in OpenBAS. You should see two active agents:

- 🟢 P14-Poste-IT (Windows IT workstation)
- 🟢 P14-SCADA-OT (Windows SCADA server)

**4. Verify PLCs**

Test Modbus connectivity from the SCADA server:
```bash
# From P14-SCADA-OT, the Flask API should be running on port 5000
curl http://localhost:5000/api/plc/1  # Incubator (10.0.0.80:502)
curl http://localhost:5000/api/plc/2  # Centrifuge (10.0.0.59:502)
```

**5. Run the Crisis Simulation**

1. Navigate to **Simulations** in OpenBAS
2. Open **"Operation: Lab Sabotage"** or your pre-configured scenario
3. Click **Start** to begin the 10-stage attack chain

---

## 🎭 Crisis Scenario Phases

### **Phase 1: Infiltration (T+0 to T+45min)**

**Step 1 - Initial Access (T+0)**  
- Phishing email targeting lab technician  
- Decision: Detect and isolate compromised workstation

**Step 2 - Reconnaissance (T+15)**  
- IDS alerts on IT→OT port scanning  
- Decision: Legitimate maintenance or adversary reconnaissance?

**Step 3 - Lateral Movement (T+30)**  
- Suspicious VPN login using stolen credentials  
- Critical Decision: Shutdown OT network or continue monitoring?

### **Phase 2: First Sabotage (T+45 to T+60min)**

**Step 4 - PLC Access (T+45)**  
- Unauthorized login to PLC using default credentials  
- HMI displays rogue "SCADA_ADMIN" session

**Step 5 - Equipment Sabotage (T+50)**  
- **Multi-vector attack:**
  - Incubator temperature manipulation (37°C → 65°C)
  - Simultaneous patient data exfiltration
- **Critical Dilemma:** Save samples OR block data theft? (2-minute decision window)

### **Phase 3: Attack Escalation (T+60 to T+120min)**

**Step 6 - Privilege Escalation (T+60)**  
- New admin account created via CVE exploit  
- Fake helpdesk ticket for legitimation  
- Attacker locks out legitimate SCADA administrator

**Step 7 - Mass Sabotage (T+75)**  
- Simultaneous alarms on all OT equipment  
- Team Vote: Total shutdown vs. Selective isolation vs. Active defense  
- Operational Triage: Red Zone (stop), Orange (manual override), Green (monitor)

**Step 8 - Data Breach (T+90)**  
- Sensitive patient data exfiltrated  
- Simulated Dark Web leak notification  
- **Legal Obligations:** GDPR notification <72 hours

### **Phase 4: Recovery (T+120 to T+150min)**

**Step 9 - Anti-Forensics (T+120)**  
- Attacker detects investigation, initiates log destruction  
- **10-minute race:** Preserve evidence before complete erasure

**Step 10 - Backdoor Discovery (T+120-T+150)**  
- Discovery: 9 backdoors (6 Windows services + 3 PLC firmware implants)  
- Final Decision: Complete rebuild vs. Targeted cleanup  
- **Twist:** 2 additional backdoors found in backup systems during recovery

---

## 🛡️ Team Roles

| Team | Primary Responsibilities | Key Decisions |
|------|-------------------------|---------------|
| **Lab Operations** | Equipment safety, sample preservation | Triage priorities during sabotage |
| **Biomedical Engineering** | PLC/OT system expertise | Technical remediation strategies |
| **IT/SI** | Network defense, incident response | Isolation, forensics, system recovery |
| **CISO** | Overall crisis coordination | Risk assessment, escalation protocols |
| **DPO** | Data protection compliance | GDPR breach notification |
| **Legal** | Regulatory obligations, liability | Law enforcement engagement |
| **Communications** | Internal/external messaging | Public disclosure strategy |

---

## 🔧 Technical Components

### **SCADA HMI Dashboard (Python HTTP Server)**
- Hosted on OpenBAS controller (10.0.0.5:8000)
- Real-time monitoring interface with live PLC data
- Alert visualization and status indicators
- Served via Python's built-in HTTP server

### **SCADA Backend API (Flask + Modbus)**
- Runs on P14-SCADA-OT Windows server (10.0.0.10:5000)
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

