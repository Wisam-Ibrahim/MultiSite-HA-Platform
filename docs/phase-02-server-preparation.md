# Phase 2 - Ubuntu Server Preparation

## Readiness check (all 3 VMs)
- SSH listens on port 22 (socket activation; the ssh.service unit shows inactive).
- Time synchronized (NTP active), UFW inactive, no unexpected open ports.
- WireGuard kernel module present (wireguard.ko.zst, kernel 7.0.0-44-generic).
- curl, wget, git, vim, python3 installed. wg and docker not installed yet.
- net.ipv4.ip_forward = 0 (will be enabled in Phase 3 on the site routers).

## Static NAT addresses
VMware VMnet8 DHCP range is 192.168.16.128 - 192.168.16.254, so .101-.103 are outside it.
Both addresses were verified unused (ping + ARP FAILED) before use.

| VM | Site NIC | Site IP | NAT NIC | NAT IP |
|----|----------|---------|---------|--------|
| MS-SITE-A-01 | ens33 | 192.168.10.1/24 | ens37 | 192.168.16.101/24 |
| MS-SITE-A-02 | ens37 | 192.168.10.2/24 | ens33 | 192.168.16.102/24 |
| MS-SITE-B-01 | ens37 | 192.168.20.1/24 | ens33 | 192.168.16.103/24 |

## Verification
- A-02 and B-01 were switched from DHCP to static using `netplan try`.
- Default route now shows `proto static` on both.
- All three VMs reach each other over 192.168.16.0/24 and reach the internet.

## Backups on the VMs
`/etc/netplan/00-installer-config.yaml.bak-phase2` (A-02 and B-01).

## Lessons learned
- Netplan files must never be copied between VMs (NIC names differ).
- YAML needs a colon after `network` and a space after `addresses:`.
- Use `netplan generate` to validate, then `netplan try` to apply safely.
