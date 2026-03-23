# Helm Lab

Build a reusable Helm chart for a small application.

## Goal
Show chart structure, values design, and template reuse.

## Scope
Chart should include:
- Deployment
- Service
- Ingress
- ConfigMap
- optional HPA
- environment-specific values

## Structure
- `demo-app/Chart.yaml`
- `demo-app/values.yaml`
- `demo-app/values-dev.yaml`
- `demo-app/values-prod.yaml`
- `demo-app/templates/*`

## Commands
```bash
helm lint demo-app
helm template demo-app demo-app
helm install demo-app demo-app
kubectl get all
```
