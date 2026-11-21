# Phase 8 - High Availability and Load Balancing (part 1)

## Application
k8s/webapp.yaml: Deployment with 3 replicas (topologySpreadConstraints) and NodePort Service 30080. Each pod prints its own name.
Pods landed on 3 different nodes (A-01, A-02, B-01).

## Load balancing proof
12 requests to NodePort on A-01 and 12 to B-01: all three pods answered (kube-proxy distribution, random, not perfectly even).

## Failure test
- First attempt (systemctl stop k3s on A-02) proved nothing: node stayed Ready and containers kept running. Documented, not used as evidence.
- Real test: k3s-killall.sh on A-02, wait 90 s.
- Result: A-02 NotReady, A-01 and B-01 Ready (API alive with 2 of 3 etcd members). 12/12 requests answered, none by the pod on A-02.
- Recovery: systemctl start k3s, all 3 nodes Ready after 60 s.

## Known limitation
Entry address is a specific node IP. If that node fails, that address stops working. Next: floating IP (keepalived).

## Issues and fixes
- First Deployment YAML failed: unquoted args containing ": " was parsed as a mapping. Fixed by quoting.

## Part 2: floating IP with keepalived
- VIP 192.168.16.100/24 (outside the VMnet8 DHCP range 128-254, verified unused by ping and ARP).
- keepalived on all 3 nodes via ansible/playbooks/keepalived.yml (Jinja template). Unicast VRRP, so it does not depend on multicast through VMware NAT.
- Priorities: A-01 150 (MASTER), A-02 100, B-01 90. Interface differs per node (A-01 ens37, others ens33) and is an inventory variable.
- Health check: the VIP moves away from a node whose k3s service is not active.
- VRRP password kept in ~/secrets (not committed), hidden with no_log.

## Failover test
- Stable state: VIP only on A-01; curl to VIP:30080 answers.
- systemctl stop keepalived on A-01: VIP moved to A-02 within 10 s; 6/6 requests answered.
- Restart on A-01: VIP returned to A-01 (preempt).
- Limitation: this stops keepalived only, not the whole VM. A full VM power-off test is planned for Phase 10.

## Terraform
Template and variables updated with vrrp_* so the generated inventory is identical to the manual one (diff = IDENTICAL).
