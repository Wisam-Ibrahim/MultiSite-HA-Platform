# Phase 11 - Automated Deploy and Health Check

## Playbooks
- ansible/playbooks/site.yml imports base, docker, k3s, keepalived, workloads in order (one command).
- ansible/playbooks/workloads.yml: copies manifests, creates the monitoring namespace and the Grafana admin Secret (password read from ~/secrets, hidden with no_log), applies webapp and monitoring.
- Result of site.yml on the running system: failed=0, changed=0 on all 3 VMs (A-01 ok=18, A-02 ok=14, B-01 ok=11), skipped=2 (K3s install and container run are skipped when already present).

## Idempotency issue found
- Apply monitoring kept reporting changed. Debug output showed one line: namespace/monitoring configured (the namespace is created by an earlier task and then re-annotated by apply). The cluster itself never changed. The changed_when condition now ignores that line. Three earlier guesses about the cause were wrong; the debug print settled it.

## Health check
scripts/healthcheck.sh: 9 checks (Ansible reach, WireGuard tunnel, cross-site ping, 3 K3s nodes Ready, VIP on exactly one node, app, Prometheus, Grafana, Prometheus targets). Result: PASSED 9, FAILED 0.

## Not automated (honest limits)
- Netplan static IPs (configs saved in configs/, applied manually).
- WireGuard keys and wg0.conf (keys are secrets generated per host).
- VM creation (no stable Terraform provider for VMware Workstation).
- site.yml was verified on a running system; a rebuild from scratch was not tested.
