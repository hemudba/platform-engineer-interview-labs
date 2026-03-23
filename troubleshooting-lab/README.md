# Troubleshooting Lab

Run short incident drills using common Kubernetes failure modes.

## Goal
Build command flow, not just theory.

## Cases
- CrashLoopBackOff
- ImagePullBackOff
- Pending pod
- DNS issue
- ingress misroute
- missing Prometheus target
- storage / CSI issue

## Files
- `cases/*.md`
- `broken-manifests/`
- `top-10-commands.md`

## Standard Debug Flow
1. identify symptom
2. inspect object state
3. inspect events
4. inspect logs
5. isolate layer
6. apply focused fix
7. verify recovery

## Common Commands
```bash
kubectl get pods -A
kubectl describe pod <name>
kubectl logs <pod>
kubectl get events -A --sort-by=.metadata.creationTimestamp
kubectl get ingress -A
kubectl get svc -A
kubectl get endpoints -A
```
