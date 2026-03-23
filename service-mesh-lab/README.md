# Service Mesh Lab

Refresh service mesh fundamentals using Istio-style resources.

## Goal
Understand when service mesh adds value and when it is overkill.

## Files
- `namespace.yaml`
- `deployment.yaml`
- `service.yaml`
- `gateway.yaml`
- `virtualservice.yaml`
- `destinationrule.yaml`
- `route-change-notes.md`

## Scope
- enable sidecar injection if available
- deploy a sample app
- expose traffic through Gateway
- control routing with VirtualService
- apply traffic policy with DestinationRule

## Commands
```bash
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f gateway.yaml
kubectl apply -f virtualservice.yaml
kubectl apply -f destinationrule.yaml
kubectl get gateway,virtualservice,destinationrule -A
```
