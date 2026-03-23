# Local Cluster vs EKS

## Topic
Understand the architectural and operational differences between running Kubernetes
locally (minikube / kind / Docker Desktop) and a managed EKS cluster on AWS.

---

## Quick Comparison Table

| Dimension              | Local (minikube / kind)              | EKS (AWS Managed)                              |
|------------------------|--------------------------------------|------------------------------------------------|
| **Control plane**      | Runs on your laptop                  | AWS-managed, multi-AZ, HA by default           |
| **Cost**               | Free                                 | $0.10/hr control plane + EC2 node costs        |
| **Setup time**         | ~2 minutes                           | ~15 minutes (Terraform apply)                  |
| **Networking**         | Flat, single-node, no VPC            | VPC, subnets, route tables, NAT gateway        |
| **IAM / RBAC**         | None — you are already cluster-admin | IAM roles for cluster + nodes, aws-auth ConfigMap |
| **Load balancers**     | NodePort or port-forward only        | Real ELB/ALB via AWS Load Balancer Controller  |
| **Persistent storage** | hostPath (local disk)                | EBS volumes via EBS CSI driver                 |
| **Node scaling**       | Manual, single node                  | Auto Scaling Groups, Cluster Autoscaler        |
| **DNS**                | CoreDNS runs locally                 | CoreDNS on nodes, Route 53 for external DNS    |
| **Image registry**     | Local Docker daemon or localhost     | ECR (private), with IAM pull permissions       |
| **TLS / Certs**        | Self-signed, auto-trusted locally    | ACM certificates, cert-manager                 |
| **Upgrades**           | Delete and recreate                  | Rolling upgrade, control plane then node groups|
| **Multi-tenancy**      | Not practical                        | Namespaces + RBAC + network policies           |
| **Observability**      | Manual setup or none                 | CloudWatch, Container Insights, Prometheus     |
| **Disaster recovery**  | None                                 | Multi-AZ nodes, etcd snapshots by AWS          |

---

## Key Architectural Differences

### 1. Control Plane Ownership
- **Local**: You own the API server, etcd, scheduler, controller-manager — they run
  as containers or processes on your machine. If your laptop sleeps, the cluster dies.
- **EKS**: AWS owns and operates the control plane. You never SSH into it. AWS handles
  etcd backups, API server HA, and version patching. You only manage worker nodes.

### 2. Networking Model
- **Local**: All pods share the same flat network. No concept of public vs private
  subnets. `kubectl port-forward` is your only ingress.
- **EKS**: Full VPC networking. Pods get real VPC IPs (via VPC CNI plugin). Traffic
  flows: internet → IGW → public subnet → ALB → private subnet → pod.

### 3. IAM Does Not Exist Locally
- **Local**: No cloud credentials needed. `kubectl` talks directly to the API server.
- **EKS**: Two layers of auth:
  1. AWS IAM authenticates who you are (via `aws eks get-token`)
  2. Kubernetes RBAC authorises what you can do (via `aws-auth` ConfigMap or
     EKS Access Entries)
  Forgetting either layer is a common interview mistake.

### 4. Persistent Storage
- **Local**: Pods write to the host filesystem. Data survives pod restarts but not
  node deletion (and there is only one node).
- **EKS**: EBS volumes are attached to specific AZs. A pod on `us-east-2a` cannot
  mount an EBS volume created in `us-east-2b`. This is a real operational gotcha.

### 5. Load Balancing
- **Local**: No cloud load balancers. `Service type: LoadBalancer` stays in `Pending`
  forever unless you use MetalLB.
- **EKS**: `Service type: LoadBalancer` triggers the AWS Load Balancer Controller,
  which reads subnet tags (`kubernetes.io/role/elb`) to provision a real ELB.
  Without correct subnet tags, provisioning silently fails.

---

## What I Built
- Provisioned an EKS cluster using raw Terraform resources (no opinionated modules)
- Created VPC with public + private subnets across 2 AZs
- NAT gateway for outbound node traffic
- IAM roles for control plane and node group with minimum required policies
- Deployed nginx Deployment + ClusterIP Service to verify node connectivity

---

## What Breaks (and Why)

| Mistake                              | Symptom                                      | Fix                                              |
|--------------------------------------|----------------------------------------------|--------------------------------------------------|
| Missing subnet tags                  | LoadBalancer stays Pending                   | Add `kubernetes.io/role/elb = 1` on public subnets |
| `depends_on` missing on node group   | Node registration fails on first apply       | Add explicit `depends_on` on IAM policy attachments |
| `enable_dns_hostnames = false`       | Nodes cannot resolve API server hostname     | Set both DNS options to `true` on VPC            |
| Nodes in public subnets              | Nodes get public IPs, exposed to internet    | Always place nodes in private subnets            |
| `public_access_cidrs` not set        | API server open to `0.0.0.0/0`               | Lock to your IP: `["x.x.x.x/32"]`               |
| `outputs.tf` references wrong names  | `terraform plan` fails immediately           | Match output refs to actual resource names       |

---

## Interview Explanation

> "Local clusters like minikube are great for developing and testing manifests quickly —
> no cost, no IAM, spins up in seconds. But they don't model production. EKS introduces
> the real complexity: VPC networking where pods get actual VPC IPs, IAM auth layered
> on top of Kubernetes RBAC, load balancers that need subnet discovery via tags, and
> node IAM roles that control what AWS services pods can reach. The gap between
> `kubectl apply` working locally and working on EKS is almost always networking or
> IAM — which is exactly what you have to understand to be effective in production."

---

## Follow-Up Questions to Expect

1. **"How does kubectl authenticate to EKS?"**
   → `aws eks get-token` exchanges AWS credentials for a short-lived bearer token.
   The EKS API server validates it against the IAM service.

2. **"What is the aws-auth ConfigMap?"**
   → Maps IAM roles/users to Kubernetes RBAC groups. If it's misconfigured, IAM
   auth succeeds but Kubernetes rejects the request with 403.

3. **"Why can't a pod on EKS just use the node's IAM role for everything?"**
   → It can, but all pods on the node share the same permissions — too broad.
   IRSA (IAM Roles for Service Accounts) scopes permissions per pod via OIDC.

4. **"What happens if you delete a node in EKS?"**
   → The ASG replaces it automatically. Pods are rescheduled by the scheduler
   onto remaining nodes. PVCs backed by EBS may block if no node is in the same AZ.

5. **"How do you upgrade an EKS cluster?"**
   → First upgrade the control plane version in Terraform, apply. Then update the
   node group version (rolling replacement of EC2 instances). Add-ons
   (CoreDNS, kube-proxy, VPC CNI) must be upgraded separately.

6. **"What is the VPC CNI plugin?"**
   → An AWS-specific CNI that assigns real VPC IPs to pods (not an overlay network).
   Each pod IP is a secondary IP on the node's ENI. This means pod IPs are
   routable inside the VPC without NAT.
