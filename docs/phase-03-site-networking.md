# Phase 3 - Site Networking (part 1: routing enabled)

## Goal
Make A-01 and B-01 able to forward packets, since they will be the
site routers and WireGuard endpoints in Phase 4.

## Change (A-01 and B-01)
File created: /etc/sysctl.d/99-ip-forward.conf
Content: net.ipv4.ip_forward=1
Applied with: sudo sysctl -p /etc/sysctl.d/99-ip-forward.conf

## Verification
- Before: net.ipv4.ip_forward = 0 on both.
- After: net.ipv4.ip_forward = 1 on both (persistent across reboots).
- No previous ip_forward setting existed (grep found nothing).

## Pending in Phase 3
Route on A-02 to 192.168.20.0/24 via A-01. It is deferred until the
WireGuard tunnel exists (Phase 4), so we do not add a route to nowhere.
It will also remove the ambiguity with the external 192.168.20.1 seen in Phase 1.
