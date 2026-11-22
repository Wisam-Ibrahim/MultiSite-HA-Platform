# Phase 13 - Closing the automation gaps

## Netplan (ansible/playbooks/netplan.yml)
- Deploys configs/<host>/00-installer-config.yaml to each VM, validates with netplan generate, applies only when the file changed.
- The saved files had Windows line endings (CRLF); converted to LF before use.
- Dry run showed only cosmetic differences (a comment line, trailing blank lines). Applied one host at a time (B-01, A-02, A-01) with healthcheck 9/9 after each. Full run afterwards: changed=0 on all VMs.

## WireGuard (ansible/playbooks/wireguard.yml)
- Generates a key pair only if missing (existing keys are never replaced), reads each public key from the host and builds wg0.conf from a template, so keys are never typed by hand.
- Private keys stay on the hosts and are hidden with no_log.
- Must be run without --limit: the template needs the peer public key from the other router. A run with --limit ms-site-a-01 failed for that reason (assumed, the message is hidden by no_log).
- Result: B-01 file already identical; A-01 changed only in key-name capitalisation; tunnel stayed up. Re-run: changed=0.

## site.yml
Now imports netplan, base, wireguard, docker, k3s, keepalived, workloads. Syntax check passed. It has not yet been run in full or used for a rebuild.

## Still not done
- VM creation (no stable Terraform provider for VMware Workstation).
- A rebuild from scratch of a node has not been tested.
