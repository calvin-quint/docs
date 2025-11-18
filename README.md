Calvin’s IT Documentation Repository

Welcome to my centralized IT Documentation & Knowledge Base.
This repository contains my work across cybersecurity, infrastructure, cloud, Intune, KQL, Linux servers, Azure, Entra ID, incident response, homelab, and data-privacy engineering.

The goal of this repo is to provide a single source of truth for reference, learning, and repeatable procedures across all my projects.

📚 What This Repo Covers

This repo includes documentation, notes, and SOPs for:

🔐 Cybersecurity & Incident Response

Threat hunting and KQL detections

Insider-threat monitoring

File exfiltration detection

USB/CloudAppEvents/DLP analysis

Forensics tooling (KAPE, FTK Imager, Autopsy)

IR playbooks for compromised endpoints

QR-code phishing investigations

Cloud security posture notes (Azure/Entra)

☁️ Azure / Entra ID

Conditional Access policies

Authentication Strength (FIDO2, WHfB)

Azure Key Vault troubleshooting

Azure FortiGate configs

Azure Arc server onboarding

Enterprise App integrations

OCSP + Private CA automation

🖥 Intune & Endpoint Management

Configuration profiles

Detection scripts (new Teams, software uninstallers, etc.)

Hardening endpoints (USB restrictions, script blocking)

Edge bookmark policies

System-context PowerShell execution

Compliance/Remediation logic

Scheduled task troubleshooting

DeviceLogonEvents and MDE event correlation

📊 KQL / Microsoft Sentinel

CloudAppEvents detections

FileUploadedToCloud + DLP queries

Insider risk queries

USB exfil queries

Mimikatz/credential-theft detections

Identity logon correlation

Suspicious PowerShell/Node.js analytics

Domain lists for data exfil monitoring

🐧 Linux / Rocky Linux / Servers

Rclone incremental backup scripts

Secure file erasure / encryption workflow

Nextcloud deployments (Docker & native install)

Cockpit usage

Samba/NFS share management

Cloudflared tunnel troubleshooting

GLIBC compatibility fixes

Cronjob automation

Server security hardening

Frigate/Kerberos.io NVR setup

🏠 Homelab Architecture

VLAN segmentation (UDM)

Docker stacks (Nextcloud, Zabbix, LAMP, AdGuard)

Cloudflare tunnels

S3 backups

Arc-enabled server design

Plex/media server notes

Virtualization environments (Proxmox, Hyper-V)

🔒 Data Privacy & Personal Security

Alias domain strategy (qalias.me, proton.me)

Email retention policies

Zero-knowledge storage workflows

VOIP privacy options

DNS, CAA, SPF/DKIM/DMARC tuning

Encrypted container folder structures

Personal digital sovereignty setup

🗂 Repo Structure (Recommended)
docs/
  ├── azure/
  ├── entra/
  ├── intune/
  ├── sentinel/
  ├── kql/
  ├── cybersecurity/
  ├── incident-response/
  ├── linux/
  ├── rocky/
  ├── rclone/
  ├── nextcloud/
  ├── docker/
  ├── fortigate/
  ├── homelab/
  ├── privacy/
  ├── scripts/
  ├── templates/
  └── notes/


If you'd like, I can output this entire folder structure with placeholder README.md files in each folder.

🧰 Tools & Technologies Covered

Microsoft Defender for Endpoint

Microsoft Sentinel

Microsoft Intune / Autopilot

Azure & Entra ID

Graph API automation

Linux (Rocky, Oracle, Ubuntu)

Docker, Compose, containers

Rclone + S3 (IDrive E2, AWS)

FortiGate (VM & hardware)

Cloudflare Zero Trust

Digital forensics suite (KAPE, FTK, Autopsy)

TrueNAS, Proxmox, Hyper-V

🎯 Purpose of This Repo

Create repeatable documentation for future reference

Build a body of work to demonstrate infrastructure, security, and automation skills

Maintain a personal “runbook” for troubleshooting

Track my progress in cybersecurity and engineering

Provide templates for future roles or projects

📌 Notes

This is a living repository.
I update it weekly as part of my Weekly Knowledge Summary Project, which consolidates all lessons learned, new detections, and configurations across my projects.

🙌 Contributions

This is a personal repo — but feedback from colleagues, mentors, and the community is always appreciated.
