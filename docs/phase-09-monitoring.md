# Phase 9 - Prometheus and Grafana

## Design (light, no kube-prometheus-stack, which is too heavy for 2.5 GB nodes)
- node-exporter: DaemonSet on all 3 nodes (hostNetwork, port 9100).
- Prometheus v2.53.0 pinned to B-01 (lightest node), retention 24h, memory limit 400Mi. Scrapes the 3 node-exporters every 15 s.
- Grafana 11.1.0 pinned to A-02, memory limit 250Mi. Data source provisioned from a ConfigMap. Admin password stored in a Kubernetes Secret created from ~/secrets/grafana-pass (not in Git).
- Access through the floating IP: Prometheus 192.168.16.100:30090, Grafana 192.168.16.100:30300.
- Image tags were checked on Docker Hub before use.

## Verification
- Prometheus targets: 3 up, no lastError.
- Grafana /api/health: database ok. Data source shows as provisioned.
- Dashboard MultiSite Nodes: CPU % per node, 3 series (screenshot in docs/screenshots).

## Known limitation
Prometheus and Grafana use emptyDir: data is lost if the pod is recreated. Local-path storage is bound to one node, so it would not survive that node failing. Also, each is a single replica pinned to one node, so they are not HA themselves.

## Issues
- First Prometheus query returned an empty result because the first scrape had not happened yet; confirmed after 30 s.
- Opened the wrong Grafana page first (Add new connection); the data source already existed through provisioning.
