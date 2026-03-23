# Terraform Lab — Setup and Handoff to kubectl

Use this after you have the Terraform skeleton in place. It closes the gap between **infra defined in Git** and **a cluster context** for the cluster inspection lab.

## 1. AWS authentication

- Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and configure credentials (or SSO).
- **Verify** you are the intended principal and account:

```bash
aws sts get-caller-identity
```

- If you use profiles:

```bash
export AWS_PROFILE=your-profile
aws sts get-caller-identity
```

## 2. Backend choice

Decide before `terraform init`:

| Approach | When to use |
|----------|-------------|
| **Local state** (`backend.tf` omitted or local) | Solo lab, no remote locking |
| **S3 + DynamoDB** (or Terraform Cloud) | Team, CI, or you want state locking |

Match `backend.tf` to your choice, then run `terraform init` (use `-reconfigure` or `-migrate-state` only when you intentionally change backends).

## 3. Region

- This lab assumes **`us-east-2`** (Ohio). Pick one region and keep it consistent in:
  - `variables.tf` / `terraform.tfvars`
  - provider `region`
  - any data sources or module calls
- **Optional check** (confirms CLI default or explicit region):

```bash
aws ec2 describe-availability-zones --region us-east-2 --query 'AvailabilityZones[0].RegionName' --output text
```

## 4. Terraform workflow

From `terraform-lab/` (or your module root):

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
```

Review the plan (VPC, subnets, IAM, EKS, node group). When satisfied:

```bash
terraform apply tfplan
```

Or interactively: `terraform apply` (only if you accept unreviewed interactive applies in your environment).

## 5. Optional: apply without saved plan

```bash
terraform apply
```

Confirm the prompt or use `-auto-approve` only when appropriate for automation, not for production learning runs.

## 6. kubeconfig for the new cluster

After apply succeeds, wire `kubectl` to the EKS API using values from your outputs (cluster name; region **`us-east-2`** for this lab):

```bash
aws eks update-kubeconfig --region us-east-2 --name <cluster-name>
```

If you use a profile:

```bash
aws eks update-kubeconfig --region us-east-2 --name <cluster-name> --profile your-profile
```

## 7. Verify with kubectl

```bash
kubectl config current-context
kubectl cluster-info
kubectl get nodes -o wide
```

You should see the managed node group nodes **Ready**. Then continue with the **cluster inspection** lab using this context.

## Quick checklist

- [ ] `aws sts get-caller-identity` succeeds
- [ ] Region (**`us-east-2`**) and backend match what you intend
- [ ] `terraform init` / `validate` / `plan` (and `apply` if provisioning)
- [ ] `aws eks update-kubeconfig` run with correct name and region
- [ ] `kubectl get nodes` shows Ready nodes
