# Phase 5 - Terraform and Ansible

## Control node
Ubuntu 24.04 in WSL2 (not the VMs, to save their 2.5 GB RAM). It reaches the VMs over 192.168.16.0/24.

## Ansible
- Passwordless SSH with an ed25519 key (private key stays in WSL, never committed).
- Passwordless sudo for the automation user via /etc/sudoers.d/90-ansible (validated with visudo -c).
- Inventory: ansible/inventory.ini (groups site_a, site_b, routers).
- ANSIBLE_CONFIG is set by environment variable because Ansible ignores ansible.cfg in a world-writable directory (/mnt/c).
- Playbook playbooks/base.yml: base packages on all VMs; wireguard-tools and persistent ip_forward on routers.
- Idempotency proof: three runs (check, run, run) all gave changed=0 failed=0.

## Terraform
- No stable VMware Workstation provider exists, so Terraform generates configuration instead of VMs.
- It renders the Ansible inventory from one variable map using templatefile and local_file.
- Result: generated inventory identical to the manual one (diff = IDENTICAL); second apply = No changes.
- Terraform runs from ~/tf-work (Linux filesystem) because NTFS under /mnt/c rejects chmod. The state file stays there and is not committed.

## Issues and fixes
- sudoers commands were first run in WSL instead of the VMs; cleaned up and re-run on each VM.
- A sudo password was displayed once by mistake; it should be changed before submission.

## Next
Phase 6: Docker and a sample application.
