# Phase 10 - Full System Testing

## Baseline (before failure)
- 3 nodes Ready, all pods Running, VIP only on A-01, WireGuard handshakes fresh, app and Prometheus answering through the VIP.

## Test: power off A-01 (VIP holder, first etcd node, Site A VPN gateway)
- VM powered off from VMware. Proof: ping to 192.168.16.101 gave Destination Host Unreachable; A-01 shown NotReady.
- VIP moved to A-02 automatically. 10 of 10 requests to VIP:30080 answered (pods on B-01 and A-02). Prometheus and Grafana answered.
- API stayed available with 2 of 3 etcd members.
- Known limitation: A-02 could not reach Site B while A-01 was down. A-01 is the only WireGuard gateway of Site A, so the VPN is a single point of failure.

## Recovery (A-01 powered on, no manual commands on it)
- 3 nodes Ready; VIP returned to A-01 (priority 150, preempt); no split-brain.
- WireGuard handshake fresh on both routers; ping A-02 to 192.168.20.1 OK (ttl=63).
- ip_forward=1 and k3s, keepalived, wg-quick@wg0 all active after boot.

## Honest notes
- Two earlier attempts were invalid because A-01 had not actually been powered off (ping still answered); they are not used as evidence.
- Earlier test (Phase 8) stopped only services, this one is a full VM power-off.

## Future improvements
- Second WireGuard gateway or a floating IP for the site router.
- Persistent storage for Prometheus and Grafana.
