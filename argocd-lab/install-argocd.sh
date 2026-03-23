#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Install ArgoCD on the EKS cluster
# INTERVIEW: ArgoCD is a pull-based GitOps controller. It runs inside the cluster
# and pulls desired state from git — the cluster is never pushed to directly.
# ---------------------------------------------------------------------------
set -euo pipefail

ARGOCD_VERSION="v2.10.4"   # INTERVIEW: always pin — breaking changes between minor versions

# 1. Create namespace
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

# 2. Install ArgoCD
# INTERVIEW: official install manifest — in production use the Helm chart
# so values (HA, ingress, SSO) are configurable without editing the manifest
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml

# 3. Wait for ArgoCD to be ready
echo "Waiting for ArgoCD pods..."
kubectl rollout status deployment argocd-server -n argocd --timeout=120s

# 4. Get initial admin password
echo ""
echo "ArgoCD admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo

# 5. Port-forward to access UI
echo ""
echo "Access ArgoCD UI:"
echo "  kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "  Then open: https://localhost:8080"
echo "  Username: admin"
