# Phase 6 - Docker and Sample Application

## Design
Docker only on A-02 (worker, no VPN endpoint) to save RAM on the routers. VMs have about 2.5 GB RAM.

## Automation
Playbook: ansible/playbooks/docker.yml (docker.io from Ubuntu repo, nginx:alpine on port 8080, page from playbooks/files/index.html).

## Problems and fixes
- Copy task failed: src is resolved next to the playbook, so the file moved to ansible/playbooks/files/.
- community.docker docker_container failed with "Not supported URL scheme http+docker" although python3-docker is 7.1.0. Root cause not determined; replaced by docker inspect check + docker run, which is idempotent through the when condition.
- An early version used a fake creates path (not idempotent) and was never run.

## Verification
- Run 1: changed=1 failed=0. Run 2: changed=0 failed=0 (container task skipped).
- curl from WSL to 192.168.16.102:8080 returns the page.
- curl from B-01 to 192.168.10.2:8080 returns the page (through WireGuard).

## Next
Phase 7: K3s cluster.
