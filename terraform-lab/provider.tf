provider "aws" {
  region = var.region

  default_tags {
    tags = merge(
      {
        Project = var.project_name
      },
      var.tags,
    )
  }
}

# Kubernetes provider — same auth pattern as Helm: exec plugin fetches a short-lived token.
provider "kubernetes" {
  host                   = aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.this.name, "--region", var.region]
  }
}

# Helm provider authenticates to EKS using the AWS CLI exec plugin.
# This avoids storing static credentials — aws eks get-token fetches
# a short-lived token the same way kubectl does.
provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.this.name, "--region", var.region]
    }
  }
}
