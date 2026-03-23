# ArgoCD Lab

Practice GitOps sync, drift detection, and reconciliation.

## Goal
Understand how desired state in Git becomes actual state in the cluster.

## Files
- `application.yaml`
- `app-of-apps.yaml`
- `drift-demo/`
- `sync-notes.md`

## Scope
- create an ArgoCD Application
- sync app to cluster
- introduce drift out of band
- observe reconciliation behavior

## Commands
```bash
kubectl apply -f application.yaml
kubectl apply -f app-of-apps.yaml
kubectl get applications -A
```
