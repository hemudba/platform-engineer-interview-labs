terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # tls: reads the OIDC issuer certificate thumbprint required by aws_iam_openid_connect_provider
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    # helm: manages the AWS Load Balancer Controller installation as a Helm release
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    # kubernetes: creates the LBC service account with the IRSA annotation
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}
