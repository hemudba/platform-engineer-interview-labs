# Ingress Pending on EKS — Why It Happens and How Orgs Fix It

## Topic
Why `kubectl get ingress` shows `ADDRESS` as blank / Pending on EKS,
and what the full solution looks like in real organisations.

---

## Why Ingress Is Always Pending by Default on EKS

An `Ingress` resource is just a **spec** — a set of routing rules written in YAML.
It does nothing on its own. Something has to read that spec and act on it.

That something is an **Ingress Controller**.

EKS does not install one by default. So when you apply an Ingress:

```
NAME            CLASS   HOSTS               ADDRESS   PORTS   AGE
nginx-ingress   alb     nginx.example.com             80      5m
```

The ADDRESS column stays empty forever because no controller is watching
for Ingress objects and provisioning load balancers.

---

## The Full Request Path (Once Fixed)

```
User browser
    │
    ▼
Route 53 (DNS)
    │  resolves nginx.example.com → ALB DNS name
    ▼
ALB (Application Load Balancer)
    │  provisioned by AWS Load Balancer Controller
    │  lives in public subnets
    │  terminates TLS via ACM certificate
    ▼
Target Group
    │  target-type: ip → pod IPs directly (VPC CNI)
    │  target-type: instance → node IP + NodePort (kube-proxy)
    ▼
Pod (nginx container)
```

---

## The Fix: AWS Load Balancer Controller

### What it does
- Watches for `Ingress` resources with `kubernetes.io/ingress.class: alb`
- Calls AWS APIs to provision an ALB, target groups, listeners, and rules
- Updates the Ingress `ADDRESS` field with the ALB DNS name
- Syncs rule changes on every `kubectl apply`

### What it needs to work

#### 1. IRSA — IAM Role for Service Account
The controller runs as a pod but needs to call AWS APIs (create ALB, register
targets, etc.). It cannot use the node IAM role — that's too broad.

IRSA creates a dedicated IAM role scoped only to this controller's service account:

```
Pod (aws-load-balancer-controller)
  → ServiceAccount (aws-load-balancer-controller)
    → IAM Role (via OIDC trust policy)
      → IAM Policy (AWSLoadBalancerControllerIAMPolicy)
        → AWS APIs (ec2, elasticloadbalancing, acm, iam)
```

Without IRSA, the controller starts but silently fails every AWS API call.

#### 2. Subnet Tags (set in our Terraform already)
```
# Public subnets  — internet-facing ALBs
kubernetes.io/role/elb = 1

# Private subnets — internal ALBs
kubernetes.io/role/internal-elb = 1

# Both subnet types
kubernetes.io/cluster/<cluster-name> = shared
```

Without these tags, the controller cannot discover which subnets to place
the ALB in. The Ingress stays Pending with no error message — a silent failure.

#### 3. Install via Helm
```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --namespace kube-system \
  --set clusterName=lab1-eks \
  --set serviceAccount.create=true \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=arn:aws:iam::ACCOUNT_ID:role/aws-lbc-role
```

---

## target-type: ip vs instance

| | `ip` (recommended) | `instance` |
|---|---|---|
| **Traffic path** | ALB → pod IP directly | ALB → node IP → kube-proxy → pod |
| **Requires** | VPC CNI (default on EKS) | Nothing extra |
| **Latency** | Lower (one hop fewer) | Higher |
| **Why it works** | VPC CNI assigns real VPC IPs to pods | Pods reachable via NodePort |
| **Security groups** | Must allow ALB SG → pod port | Must allow ALB SG → node NodePort range |

Use `ip` mode on EKS. It is more efficient and avoids kube-proxy double-NAT.

---

## How Organisations Handle It

### Small teams / startups
- Install AWS Load Balancer Controller via Helm in the cluster bootstrap pipeline
- One Ingress per service with ALB annotations
- ACM handles TLS — no manual certificate management

### Mid-size organisations
- AWS LBC installed via Terraform `helm_release` resource (infra-as-code)
- IRSA created by Terraform alongside the cluster
- Shared ALB across multiple Ingress objects using `alb.ingress.kubernetes.io/group.name`
  annotation — reduces ALB cost (one ALB = ~$20/month)

```yaml
# Multiple services share one ALB
annotations:
  alb.ingress.kubernetes.io/group.name: production
```

### Enterprise
- nginx-ingress controller on an NLB for full control over routing behaviour
- or Kong / Ambassador for API gateway features (rate limiting, auth, plugins)
- or Service Mesh (Istio / Linkerd) handles internal traffic; LBC only for edge
- Wildcard ACM certificates + external-dns for automatic Route 53 record creation

---

## What I Built
- `networking-lab/ingress.yaml` with ALB annotations, HTTPS, ip target-type
- Subnet tags already set in `terraform-lab/main.tf`
- AWS Load Balancer Controller install command documented (not applied — no live cluster)

---

## What Breaks (and Why)

| Mistake | Symptom | Fix |
|---|---|---|
| No ingress controller installed | ADDRESS stays blank forever | Install AWS LBC via Helm |
| Missing subnet tags | Ingress Pending, no error | Add `kubernetes.io/role/elb = 1` to public subnets |
| Wrong IRSA annotation | Controller starts, all AWS calls fail silently | Verify role ARN annotation on ServiceAccount |
| `target-type: instance` with security group blocking NodePort | 504 gateway timeout | Use `ip` mode or open NodePort range in SG |
| ACM cert in wrong region | Listener creation fails | ACM cert must be in same region as the ALB |
| `ingress.class: nginx` on EKS with ALB LBC | Ingress ignored by controller | Use `alb` class for AWS LBC |

---

## Interview Explanation

> "On EKS, an Ingress resource does nothing out of the box — there's no controller
> watching for it. The standard fix is installing the AWS Load Balancer Controller,
> which reads Ingress objects and calls AWS APIs to provision an ALB. The two things
> that silently break it are missing subnet tags — the controller can't find where
> to place the ALB — and missing IRSA, so the controller can't authenticate to AWS
> APIs at all. In most orgs this is set up once as part of cluster bootstrap via
> Terraform and Helm, and developers just write Ingress YAML and get a working ALB
> automatically."

---

## Follow-Up Questions to Expect

1. **"What is the difference between an Ingress and a Service type LoadBalancer?"**
   → `LoadBalancer` provisions one NLB per Service — expensive and L4 only.
   `Ingress` provisions one ALB shared across many services — L7, host/path routing,
   TLS termination, cheaper at scale.

2. **"What is IRSA and why does the LBC need it?"**
   → IRSA maps a Kubernetes ServiceAccount to an IAM role via OIDC federation.
   The controller needs to call EC2 and ELB APIs to manage load balancers.
   Without it, the pod has no AWS credentials and every API call fails.

3. **"How do multiple teams share one ALB?"**
   → Using `alb.ingress.kubernetes.io/group.name` annotation. Each team's Ingress
   resource declares the same group name. The controller merges them into one ALB
   with separate listener rules. One ALB instead of N ALBs.

4. **"What is VPC CNI and why does target-type ip depend on it?"**
   → VPC CNI is the AWS CNI plugin that assigns real VPC IP addresses to pods.
   Because pod IPs are native VPC IPs, the ALB can route directly to them without
   going through kube-proxy. Without VPC CNI (e.g. Calico overlay), pod IPs are
   not routable in the VPC and ip mode would fail.

5. **"How do you automate DNS when a new Ingress is created?"**
   → `external-dns` controller watches Ingress objects, reads the `host` field,
   and creates/updates Route 53 records pointing to the ALB DNS name automatically.
