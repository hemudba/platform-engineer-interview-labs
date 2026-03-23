# Observability Lab

Review Prometheus, Grafana, and basic alerting priorities.

## Goal
Understand what to monitor first in a new cluster and how to separate symptoms from causes.

## Scope
- inspect Prometheus targets
- inspect Grafana dashboards
- create or review 3 alert rules
- identify top cluster signals

## Priority Signals
- node health
- pod restart spikes
- target down
- resource saturation

## Files
- `argocd/` — **GitOps**: multi-source Applications (Helm registry + Git values via `$values`); see `argocd/README.md`
- `helm/` — **Helm CLI / umbrella charts**: same versions as Argo CD path (see `helm/README.md`)
- `prometheus/alert-rules.yaml` (add when you author rules)
- `grafana/dashboard-notes.md` (add for lab notes)
- `observability-runbook.md` (add for runbook)

## Commands
See `helm/README.md` for `helm dependency build`, `helm install`, and value overlays (`values-dual-cluster.yaml`). Document UI checks and `kubectl` port-forwards here as you run the lab.

## Mini Practical
- pick one failing or noisy target
- inspect likely cause
- write next action

## What I Must Be Able to Explain
- Prometheus vs Grafana
- alerting priorities
- infra symptoms vs app symptoms
- what I monitor first in a fresh cluster
- how noisy alerts damage trust

## Deliverables
- 3 sample alerts
- concise runbook
- dashboard priority notes

## Completion Check
- I can name the top 3 alerts and why they matter
- I can explain symptom vs cause clearly
- I can speak about observability without being tool-only
