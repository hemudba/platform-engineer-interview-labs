# -----------------------------------------------------------------------------
# AWS Load Balancer Controller — installed via Helm
# -----------------------------------------------------------------------------
# INTERVIEW: chart version and IAM policy must come from the same LBC release.
# Mismatch = controller starts healthy but fails on missing IAM permissions.
# Always pin both together and update them as a pair.
#
# Helm chart → Controller version mapping:
#   chart 1.7.x  → controller v2.7.x
#   chart 1.8.x  → controller v2.8.x
#   chart 1.11.x → controller v2.11.x
# -----------------------------------------------------------------------------

locals {
  lbc_chart_version = "1.8.0"
}

resource "helm_release" "aws_lbc" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = local.lbc_chart_version
  namespace  = "kube-system"

  # INTERVIEW: create=false because we manage the service account via IRSA (irsa.tf).
  # If create=true, Helm creates a service account without the role-arn annotation
  # and the controller cannot authenticate to AWS APIs.
  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = aws_eks_cluster.this.name
  }

  # INTERVIEW: region is required so the controller calls the correct AWS regional endpoints
  set {
    name  = "region"
    value = var.region
  }

  # INTERVIEW: vpcId is required for the controller to discover subnets and security groups
  set {
    name  = "vpcId"
    value = aws_vpc.this.id
  }

  # Ensures IAM role and OIDC provider exist before Helm tries to deploy the controller
  depends_on = [
    aws_iam_role_policy_attachment.lbc,
    aws_iam_openid_connect_provider.eks,
  ]
}

# -----------------------------------------------------------------------------
# Service Account with IRSA annotation
# -----------------------------------------------------------------------------
# INTERVIEW: this wires the Kubernetes service account to the IAM role.
# The annotation is what IRSA reads — without it the pod gets no AWS credentials.
# The controller pod assumes this identity to call EC2 and ELB APIs.
resource "kubernetes_service_account" "lbc" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.lbc.arn
    }
  }

  depends_on = [aws_eks_cluster.this]
}
