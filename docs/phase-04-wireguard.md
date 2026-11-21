# Phase 4 - WireGuard VPN

## Design
Tunnel between A-01 and B-01 over the NAT network (192.168.16.0/24).

| | A-01 | B-01 |
|--|------|------|
| Endpoint | 192.168.16.101:51820 | 192.168.16.103:51820 |
| wg0 address | 10.10.10.1/24 | 10.10.10.2/24 |
| Network behind | 192.168.10.0/24 | 192.168.20.0/24 |

## Steps
1. Installed wireguard-tools (v1.0.20250521) on A-01 and B-01.
2. Generated key pairs in /etc/wireguard (root only, mode 600).
3. Wrote /etc/wireguard/wg0.conf on both (private key injected from file, never typed).
4. Verified public keys by SHA-256 fingerprint. B-01 first held a wrong A-01 key; fixed by transferring the key over SSH.
5. Enabled with: systemctl enable --now wg-quick@wg0 (starts on boot).

## Verification
- ping 10.10.10.2 and 10.10.10.1: 0% loss, ttl=64.
- wg show: latest handshake present, traffic in both directions.
- ip route get 192.168.20.1 -> dev wg0.
- ping 192.168.20.1 from A-01 -> ttl=64 (B-01). This resolves the Phase 1 ambiguity (ttl 128/250 came from the external network).

## Security notes
- Private keys stay on the VMs and are never committed (.gitignore).
- A-01 private key was shown once by mistake, deleted and regenerated before use.
- Repo contains only wg0.conf.example files without PrivateKey.

## Pending
A-02 does not know the tunnel yet: route to 192.168.20.0/24 via A-01 and forwarding rules.
