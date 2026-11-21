# Phase 3 - Site Networking

## Part 1: routing enabled
A-01 and B-01: /etc/sysctl.d/99-ip-forward.conf with net.ipv4.ip_forward=1 (persistent).

## Part 2: routes on A-02 (after the WireGuard tunnel existed)
A-02 needs two static routes via A-01 (192.168.10.1) on ens37:
- 192.168.20.0/24 : reach Site B through the tunnel.
- 10.10.10.0/24 : tunnel network, so replies to packets sourced from the B-01 wg0 address come back through A-01.

## Problem found and diagnosis
- A-02 to 192.168.20.1 worked (ttl=63), but B-01 to 192.168.10.2 gave 100% loss.
- B-01 uses its wg0 address 10.10.10.2 as source (ip route get showed src 10.10.10.2).
- A-02 had no route to 10.10.10.0/24, so replies went to the NAT gateway and were lost.
- Proof: ping -I 192.168.20.1 from B-01 worked. After adding the 10.10.10.0/24 route, both directions worked.

## Verification after reboot
- A-01: ip_forward = 1, WireGuard handshake restored, ping 10.10.10.2 OK.
- A-02: both static routes present, ping 192.168.20.1 OK (ttl=63).
- B-01: ping 192.168.10.2 OK (ttl=63).

## Backup on A-02
/etc/netplan/00-installer-config.yaml.bak-phase3
