# Networking Lab

Practice Kubernetes networking from workload to service to ingress.

## Goal
Understand and demonstrate:
- pod networking
- Service behavior
- Ingress routing
- NetworkPolicy basics

## Files
- `deployment.yaml`
- `service.yaml`
- `ingress.yaml`
- `networkpolicy.yaml`
- `broken-ingress.yaml`
- `debug-notes.md`

## Scope
Create a small app and expose it through:
- Deployment
- Service
- Ingress

Optionally restrict traffic with NetworkPolicy.

## Commands
```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml
kubectl apply -f networkpolicy.yaml
kubectl get all
kubectl describe ingress <name>
```
