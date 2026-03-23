# Observability — Argo CD (multi-source)

Declarative Applications that pull **Helm charts from chart repositories** and **values from this Git repo** using the [`$values` ref pattern](https://argo-cd.readthedocs.io/en/stable/user-guide/multiple-sources/) (Argo CD 2.6+).

| Manifest | Chart | Values (Git) |
|----------|-------|----------------|
| `observability-workload-app.yaml` | `kube-prometheus-stack` 82.13.2 | `values-argocd.yaml` + `values-argocd-dual-cluster.yaml` |
| `observability-obs-grafana-app.yaml` | `grafana` 10.5.15 | `values-grafana-argocd.yaml` |
| `observability-obs-alertmanager-app.yaml` | `alertmanager` 1.14.0 | `values-alertmanager-argocd.yaml` |

## Why two Applications for the obs cluster?

An Argo CD `Application` maps to **one** Helm release. Your diagram showed three sources (Grafana chart + Alertmanager chart + Git values). That becomes **two** Applications that share the same Git `ref: values` and the same destination namespace (`observability`).

## Single-cluster workload (optional)

To run **without** the dual-cluster overlay (local Grafana + Alertmanager on the workload cluster), edit `observability-workload-app.yaml` and remove the second `valueFiles` entry so only `values-argocd.yaml` is used.

## Apply

```bash
kubectl apply -f observability-lab/argocd/
```

Adjust `repoURL` / `targetRevision` in each file to match your fork and pinned branches.

## Keep versions aligned

When bumping chart versions, update:

- `targetRevision` in these Application manifests
- `Chart.yaml` / `Chart.lock` under `observability-lab/helm/*` (umbrella / manual Helm path)
- `values-argocd*.yaml` when upstream value schemas change
