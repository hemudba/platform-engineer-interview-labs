# Observability stack (Helm, production-style)

Two **umbrella charts** wrap upstream, maintained charts so installs stay versioned and reviewable in Git:

| Chart | Upstream | Use |
|-------|----------|-----|
| `workload-cluster/` | [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) | Workload cluster: Prometheus Operator, Prometheus, Alertmanager, exporters, default rules/dashboards. |
| `obs-cluster/` | [grafana](https://github.com/grafana/helm-charts/tree/main/charts/grafana) + [alertmanager](https://github.com/prometheus-community/helm-charts/tree/main/charts/alertmanager) | Observability cluster: central Grafana and **central Alertmanager** (platform team). |

`Chart.lock` pins exact dependency digests. Run **`helm dependency build`** (or **`helm dependency update`** after editing `Chart.yaml`) so the lock matches `Chart.yaml` — CI runs `helm dependency build` after checkout.

## Prerequisites

- Helm 3.14+ recommended
- Repos (idempotent):

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

## Workload cluster (metrics + optional local Grafana)

```bash
cd workload-cluster
helm dependency build
helm install kps . -n monitoring --create-namespace -f values.yaml
```

**Dual-cluster layout** (Grafana only on `obs-cluster`): merge the overlay so bundled Grafana is not installed twice:

```bash
helm install kps . -n monitoring --create-namespace -f values.yaml -f values-dual-cluster.yaml
```

Expose the workload Prometheus Service (for the obs cluster datasource) with your platform standard — for example a k3d port map on the host.

## Observability cluster (central Grafana + Alertmanager)

```bash
cd obs-cluster
helm dependency build
helm install obs . -n observability --create-namespace -f values.yaml
```

Point Grafana at the workload Prometheus URL using `values-datasources.example.yaml` as a template (copy to a local, untracked file and pass `-f`).

**Dual-cluster:** set `REPLACE_ME_OBS_CLUSTER_ALERTMANAGER:9093` in `workload-cluster/values-dual-cluster.yaml` to the obs-cluster Alertmanager Service DNS name or reachable host (see `kubectl get svc -n observability`).

**Security:** replace `adminPassword` with `grafana.admin.existingSecret` (or inject via CI) before any shared environment.

## Bumping chart versions

1. Edit `Chart.yaml` `dependencies[].version`.
2. Run `helm dependency update` in that chart directory (refreshes `Chart.lock` and `charts/*.tgz`).
3. Re-run `helm template` / `helm lint` and apply in a non-prod cluster first.
4. Update `targetRevision` in `../argocd/*.yaml` and keep the same semantics in `values-argocd*.yaml` (flat keys for upstream charts) as in `values.yaml` (nested under `kube-prometheus-stack:` for umbrellas).

## Argo CD (multi-source)

Charts from **Helm repos** + values from **Git** are documented in **`../argocd/README.md`**. Use **`values-argocd.yaml`** / **`values-grafana-argocd.yaml`** / **`values-alertmanager-argocd.yaml`** for direct chart installs (no umbrella nesting).
