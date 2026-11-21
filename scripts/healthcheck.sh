#!/bin/bash
# Full system check. Run from WSL inside the ansible folder context.
cd "$(dirname "$0")/../ansible" || exit 1
VIP=192.168.16.100
pass=0; fail=0
check() { # name, command
  if eval "$2" >/dev/null 2>&1; then echo "PASS  $1"; pass=$((pass+1)); else echo "FAIL  $1"; fail=$((fail+1)); fi
}
check "SSH/Ansible reaches 3 VMs" "[ \$(ansible all -m ping 2>/dev/null | grep -c SUCCESS) -eq 3 ]"
check "WireGuard A-01 to B-01 tunnel (10.10.10.2)" "ansible ms-site-a-01 -m command -a 'ping -c 2 -W 2 10.10.10.2'"
check "A-02 reaches Site B (192.168.20.1)" "ansible ms-site-a-02 -m command -a 'ping -c 2 -W 2 192.168.20.1'"
check "K3s: 3 nodes Ready" "[ \$(ansible ms-site-a-01 -m command -a 'k3s kubectl get nodes --no-headers' --become 2>/dev/null | grep -c ' Ready ') -eq 3 ]"
check "VIP held by exactly one node" "[ \$(ansible all -m shell -a 'ip -br addr | grep -c $VIP' --become 2>/dev/null | grep -c '^1\$') -eq 1 ]"
check "App answers through VIP:30080" "curl -s --max-time 5 http://$VIP:30080 | grep -q Pod"
check "Prometheus ready through VIP:30090" "curl -s --max-time 5 http://$VIP:30090/-/ready | grep -q Ready"
check "Grafana healthy through VIP:30300" "curl -s --max-time 5 http://$VIP:30300/api/health | grep -q ok"
check "Prometheus: 3 targets up" "[ \$(curl -s --max-time 5 'http://$VIP:30090/api/v1/targets' | grep -o '\"health\":\"up\"' | wc -l) -eq 3 ]"
echo "----"; echo "PASSED: $pass   FAILED: $fail"
[ $fail -eq 0 ]
