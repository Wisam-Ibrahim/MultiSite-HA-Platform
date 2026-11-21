# Automated Multi-Site Infrastructure with Kubernetes High Availability

University project: two virtual sites connected by a WireGuard VPN, with a 3-node K3s cluster (embedded etcd, HA), a floating IP with load balancing, and Prometheus/Grafana monitoring. Built and automated with Ansible and Terraform.

## Environment
- Host: Windows 11, VMware Workstation Pro, 16 GB RAM
- 3 VMs: Ubuntu Server 26.04.1 LTS (MS-SITE-A-01, MS-SITE-A-02, MS-SITE-B-01), 2 vCPU and about 2.5 GB RAM each
- Control node: Ubuntu 24.04 in WSL2 (Ansible, Terraform)

## Roadmap
| # | Phase | Status |
|---|-------|--------|
| 1 | Inspect existing VMs and setup | Done |
| 2 | VMware networks and Ubuntu servers | Done |
| 3 | Site A / Site B networking | Done |
| 4 | WireGuard VPN | Done |
| 5 | Terraform and Ansible | Done |
| 6 | Docker and sample application | Done |
| 7 | K3s cluster | Done |
| 8 | High Availability and Load Balancing | Done |
| 9 | Prometheus and Grafana | Done |
| 10 | Full system testing | Done |
| 11 | Automated deploy and health check | Done |
| 12 | Final documentation and presentation | Pending |

Details for each phase are in the docs folder.

Secrets (WireGuard private keys, K3s token, VRRP and Grafana passwords) are kept outside this repository.
