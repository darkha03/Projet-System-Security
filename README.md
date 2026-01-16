# Project System Security - Crisis Management

**Automated Red Team Lab | Infrastructure as Code | Ransomware Simulation**

This repository contains the complete **Infrastructure as Code (IaC)** configuration to deploy a fully automated Cyber Range using **Ludus**. It provisions an OpenBAS Attack Simulation controller and two victim machines (Windows 10 & Windows Server 2019), pre-configured with a custom adversarial scenario.

## 🏗️ Architecture

The lab consists of three Virtual Machines deployed on Proxmox via Ludus:

| Role | Hostname | IP Address | OS | Function |
| :--- | :--- | :--- | :--- | :--- |
| **Controller** | `openbas-controller` | `192.168.20.5` | Debian 12 | Runs OpenBAS (Docker), PostgreSQL, and MinIO. |
| **Victim 1** | `victim-workstation` | `192.168.20.10` | Windows 10 | Entry point for the attack (Phishing target). |
| **Victim 2** | `victim-server` | `192.168.20.20` | Server 2019 | Domain Controller / High-value target. |

---

## 📂 Repository Structure

```text
openbas-lab/
├── config.yml                  # Main Ludus Range configuration
├── roles/
│   ├── openbas-server/         # Ansible role for the Controller
│   │   ├── tasks/main.yml      # Installs Docker & Restores Database
│   │   └── files/
│   │       ├── docker-compose.yml # Container definition (Persistent Volumes)
│   │       └── init_lab.sql       # Database Snapshot (Pre-loaded Scenario)
│   └── openbas-agent-win/      # Ansible role for Victims
│       └── tasks/main.yml      # Auto-installs OpenBAS Agent via PowerShell
```

## 🚀 Getting Started

**Prerequisites**

- A running Ludus instance.
- Proxmox templates for Debian 12, Windows 10, and Windows Server 2019.

**Deployment Guide**

**1. Clone this repository onto your Ludus host:**
```bash
git clone https://github.com/darkha03/Projet-System-Security.git
cd Projet-System-Security
```

**2. Modify the environement:**

Change the env variable in ./roles/openbas-server/files/.env.example

**3. Deploy the Range:**
```bash
ludus range deploy -t .
```
**4. Wait for Provisioning**: 

Ludus will spin up the VMs, install Docker, restore the OpenBAS database, and install the agents on the Windows machines. This usually takes 10-15 minutes.

## 💻 Access & Usage

**1. Access the Dashboard**

Open your browser and navigate to:

- URL: http://192.168.20.5:8080
- Email: admin@openbas.io (Check .env)
- Password: YourSuperSecurePassword (Check .env or Ansible vars)

**2. Verify Agent**

Go to Assets > Agents. You should see two active agents:

- 🟢 victim-workstation
- 🟢 victim-server

**3. Run the Simulation**

1. Navigate to Simulations.
2. Open "Operation Smoke & Mirrors".
3. Click Start to begin the attack chain.

