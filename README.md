@'

# Automated Multi-Site Infrastructure with Kubernetes High Availability

University project: two virtual sites connected by a WireGuard VPN,
with a K3s Kubernetes cluster (HA), load balancing, and monitoring.

## Technologies

Linux Networking, Netplan, WireGuard, Terraform, Ansible, Docker,
K3s, Load Balancing, Prometheus, Grafana, GitHub.

## Environment

- Host: Windows 11, VMware Workstation Pro, 16 GB RAM
- Guests: Ubuntu Server 26.04.1 LTS (3 VMs)

## Roadmap

| #   | Phase                                        | Status  |
| --- | -------------------------------------------- | ------- |
| 1   | Inspect existing VMs and setup               | Done    |
| 2   | VMware networks and Ubuntu servers           | Pending |
| 3   | Site A / Site B networking (Netplan)         | Pending |
| 4   | WireGuard VPN                                | Pending |
| 5   | Terraform and Ansible                        | Pending |
| 6   | Docker and sample application                | Pending |
| 7   | K3s cluster                                  | Pending |
| 8   | High Availability and Load Balancing         | Pending |
| 9   | Prometheus and Grafana                       | Pending |
| 10  | Full system testing                          | Pending |
| 11  | Automated deploy and rebuild                 | Pending |
| 12  | Documentation, screenshots, presentation     | Pending |
| '@  | Set-Content -Path .\README.md -Encoding UTF8 |

# --- docs/phase-01-inspection.md ---

@'

# Phase 1 - Inspection of the Existing Environment

All data below was collected from real command output (read-only checks).

## VM inventory

| VM           | Site NIC       | Site IP         | NAT NIC        | NAT IP            | NAT IP type |
| ------------ | -------------- | --------------- | -------------- | ----------------- | ----------- |
| MS-SITE-A-01 | ens33 (VMnet2) | 192.168.10.1/24 | ens37 (VMnet8) | 192.168.16.101/24 | Static      |
| MS-SITE-A-02 | ens37 (VMnet2) | 192.168.10.2/24 | ens33 (VMnet8) | 192.168.16.135/24 | DHCP        |
| MS-SITE-B-01 | ens37 (VMnet3) | 192.168.20.1/24 | ens33 (VMnet8) | 192.168.16.137/24 | DHCP        |

- OS: Ubuntu 26.04.1 LTS, kernel 7.0.0-44-generic
- Resources per VM: 2 vCPU, 3 GB RAM assigned (about 2.5 GB visible), 25 GB disk
- NAT gateway: 192.168.16.2

## VMware virtual networks

| Network         | Type   | Host adapter       | DHCP     | Subnet          |
| --------------- | ------ | ------------------ | -------- | --------------- |
| VMnet2 (Site A) | Custom | No                 | Disabled | 192.168.10.0/24 |
| VMnet3 (Site B) | Custom | No                 | Disabled | 192.168.20.0/24 |
| VMnet8          | NAT    | Yes (192.168.16.1) | Enabled  | 192.168.16.0/24 |

## Findings

1. NIC names differ between A-01 and A-02/B-01 (adapter order in VMware differs).
   Netplan files must never be copied between VMs without checking interface names.
2. A-02 and B-01 get their NAT address by DHCP. They will be made static in Phase 3.
3. Site A and Site B are isolated from each other (no router between VMnet2 and VMnet3).
   The WireGuard tunnel will travel over VMnet8 (192.168.16.0/24).
4. A ping from A-01 to 192.168.20.1 succeeded, but it did NOT reach B-01.
   The route went via the NAT gateway to the outside network, where an
   address 192.168.20.1 also answers (seen from Windows too, via the ISP path).
   Verification plan: after WireGuard is up, the route for 192.168.20.0/24
   must use wg0, and replies must show TTL=64 (Linux).
   '@ | Set-Content -Path .\docs\phase-01-inspection.md -Encoding UTF8

# --- .gitignore (ASCII on purpose: a BOM would break the first line) ---

@'

# Secrets - never commit

_.key
_.pem
privatekey
_.tfstate
_.tfstate._
.terraform/
.env
_.retry

# OS / editor

Thumbs.db
.vscode/
'@ | Set-Content -Path .\.gitignore -Encoding ASCII
