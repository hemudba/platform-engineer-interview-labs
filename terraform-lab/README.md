# Terraform Lab

Build a minimal but interview-quality EKS stack with Terraform.

## Goal
Understand and explain the build order for:
- provider
- backend
- networking
- IAM
- EKS control plane
- managed node group
- outputs

## Files
- `versions.tf` — Terraform and provider constraints
- `provider.tf` — AWS provider and default tags
- `backend.tf` — local state by default; optional S3 backend template
- `main.tf` — VPC + EKS modules
- `variables.tf`
- `outputs.tf`
- `terraform.tfvars.example`
- `SETUP.md` — AWS → Terraform → kubeconfig handoff
- `scripts/install-terraform-wsl.sh` — optional Terraform install for WSL

## Scope
This lab should provision or model:
- VPC
- subnets
- route tables as needed
- IAM roles
- EKS cluster
- managed node group
- useful outputs

## Prerequisites
Before running Terraform, confirm:
- Terraform is installed
- AWS CLI is installed
- AWS authentication works
- correct AWS region is chosen
- backend approach is decided
- local repo structure is ready

For AWS auth, backend and region choices, full `init`/`plan`/`apply`, and `aws eks update-kubeconfig` → `kubectl` checks, use **`SETUP.md`**.

## Build Order
1. backend and provider
2. VPC and subnets
3. IAM roles and policies
4. EKS control plane
5. managed node group
6. outputs
7. later production add-ons such as ingress, observability, GitOps bootstrap

## Commands
```bash
terraform fmt
terraform validate
terraform plan
```
