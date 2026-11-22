# Phase 14 - Rebuild test of node B-01 from code

## Preparation
- VMware snapshot before-rebuild taken; healthcheck 9/9.
- Snapshots taken while the VMs were running; a healthcheck right afterwards showed one failure (K3s 3 nodes Ready) that did not repeat. All nodes had Ready transition times from hours earlier, so cause unknown.

## Procedure
1. kubectl drain ms-site-b-01 (first attempt was undone by an uncordon I ran by mistake; repeated).
2. k3s-uninstall.sh on B-01, then kubectl delete node. Journal shows the etcd member of B-01 was removed.
3. Removed WireGuard (service and /etc/wireguard) on B-01.
4. ansible-playbook playbooks/site.yml (full, no --limit).

## Result
- site.yml: failed=0 on all VMs; B-01 changed=6 (new WireGuard keys, wg0.conf, K3s join).
- A-01 wg0.conf updated automatically with the new B-01 public key; handshake fresh on both routers.
- 3 nodes Ready (B-01 age 3 min), Prometheus rescheduled to B-01, healthcheck 9/9.
- Second site.yml run: changed=0 on all VMs.

## Honest scope
Rebuilt from code: K3s membership, WireGuard keys and config, workloads. Not rebuilt: the Ubuntu install, the Netplan state, and VM creation itself (manual).

## Cost
Site B was cut off from Site A during the test, and Prometheus data was lost (emptyDir).
