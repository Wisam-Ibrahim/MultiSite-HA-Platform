# Phase 8 - High Availability and Load Balancing (part 1)

## Application
k8s/webapp.yaml: Deployment with 3 replicas (topologySpreadConstraints) and NodePort Service 30080. Each pod prints its own name.
Pods landed on 3 different nodes (A-01, A-02, B-01).

## Load balancing proof
12 requests to NodePort on A-01 and 12 to B-01: all three pods answered (kube-proxy distribution, random, not perfectly even).

## Failure test
- First attempt (systemctl stop k3s on A-02) proved nothing: node stayed Ready and containers kept running. Documented, not used as evidence.
- Real test: k3s-killall.sh on A-02, wait 90 s.
- Result: A-02 NotReady, A-01 and B-01 Ready (API alive with 2 of 3 etcd members). 12/12 requests answered, none by the pod on A-02.
- Recovery: systemctl start k3s, all 3 nodes Ready after 60 s.

## Known limitation
Entry address is a specific node IP. If that node fails, that address stops working. Next: floating IP (keepalived).

## Issues and fixes
- First Deployment YAML failed: unquoted args containing ": " was parsed as a mapping. Fixed by quoting.
