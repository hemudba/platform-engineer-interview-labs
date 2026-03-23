# Policy Lab

Apply policy as code to enforce baseline guardrails.

## Goal
Practice admission control and explain audit vs enforce tradeoffs.

## Scope
Create policies such as:
- block privileged containers
- require resource requests and limits
- require labels

## Files
- `kyverno/require-labels.yaml`
- `kyverno/require-resources.yaml`
- `kyverno/block-privileged.yaml`
- `test-manifests/compliant.yaml`
- `test-manifests/non-compliant.yaml`
- `policy-notes.md`

## Commands
```bash
kubectl apply -f kyverno/
kubectl apply -f test-manifests/non-compliant.yaml
kubectl apply -f test-manifests/compliant.yaml
```
