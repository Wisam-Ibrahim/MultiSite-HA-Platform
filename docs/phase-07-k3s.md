# Phase 7 - K3s Cluster

## Design
3 server nodes with embedded etcd (A-01 cluster-init, A-02 and B-01 join). Version pinned: v1.37.2+k3s1 (stable channel at install time).
Nodes communicate over the NAT network (192.168.16.101-103) using --node-ip. Traefik and ServiceLB disabled to save RAM; load balancing is configured in Phase 8.

## Automation
ansible/playbooks/k3s.yml. The cluster token is generated with openssl on the control node (~/secrets/k3s-token), read with lookup, never committed, hidden with no_log.
Installed one node at a time using --limit; joins use serial: 1.

## Verification
- All three nodes Ready with roles control-plane,etcd.
- kube-system pods Running (coredns, local-path-provisioner, metrics-server); readyz check passed including etcd.
- Memory available after install: A-01 1425 MB, B-01 1756 MB (before install about 2090 MB each).

## Notes
- Quorum is 2 of 3, so one node failure should be tolerated. This is tested in Phase 8, not assumed.
- Node traffic uses the NAT network, not the WireGuard tunnel. The tunnel carries cross-site application traffic.

## Next
Phase 8: High Availability testing and load balancing.
