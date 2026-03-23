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
- `prometheus/alert-rules.yaml`
- `grafana/dashboard-notes.md`
- `observability-runbook.md`

## Commands
Document relevant commands and UI checks here.

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
