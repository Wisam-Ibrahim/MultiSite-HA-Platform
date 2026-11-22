# Automated Multi-Site Infrastructure with Kubernetes High Availability

Two virtual sites joined by a WireGuard VPN, a 3-node K3s cluster (embedded etcd), a floating IP (keepalived), and Prometheus/Grafana monitoring. Automated with Ansible and Terraform.

## Architecture
```
            Windows 11 host (VMware, VMnet8 NAT 192.168.16.0/24)
                    VIP 192.168.16.100 (keepalived)
   +----------------------+          +----------------------+
   | SITE A 192.168.10/24 |  WireGuard| SITE B 192.168.20/24 |
   | A-01 .10.1 (router)  |<========>| B-01 .20.1 (router)  |
   | A-02 .10.2           | 10.10.10.x|                      |
   +----------------------+          +----------------------+
   K3s servers: A-01 .16.101, A-02 .16.102, B-01 .16.103
```

## Components
| Layer | Tool |
|-------|------|
| Networking | Netplan, static routes, WireGuard (10.10.10.0/24) |
| Orchestration | K3s v1.37.2, 3 servers, embedded etcd |
| Load balancing | kube-proxy NodePort + keepalived VIP |
| Monitoring | node-exporter, Prometheus 2.53.0, Grafana 11.1.0 |
| Automation | Ansible (site.yml), Terraform (inventory generation) |

## Run
From WSL (control node):
```
cd ansible
ansible-playbook playbooks/site.yml
bash ../scripts/healthcheck.sh
```

## Phases
See docs/phase-01 to docs/phase-11.

## Verified results
- Health check: 9 of 9 PASS.
- Full VM power-off of A-01: VIP moved to A-02, 10 of 10 requests answered, API stayed up with 2 of 3 etcd members; everything returned by itself after power-on.

## Known limitations
- WireGuard gateway of each site is a single point of failure (Site A lost Site B access while A-01 was down).
- Prometheus and Grafana are single replicas on emptyDir (data not persistent).
- VM creation is not automated, and a rebuild of a node from scratch has not been tested yet. Netplan and WireGuard are now automated (phase 13).
- Ubuntu on the VMs is 26.04.1.

## Secrets
WireGuard keys, K3s token, VRRP and Grafana passwords live outside the repository (.gitignore).

