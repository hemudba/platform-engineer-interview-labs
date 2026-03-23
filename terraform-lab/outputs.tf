output "region" {
  description = "AWS region the cluster was deployed to."
  value       = var.region
}

output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

output "cluster_name" {
  description = "EKS cluster name (pass to --name in aws eks update-kubeconfig)."
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "Kubernetes API server endpoint."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded cluster CA certificate (needed by advanced Kubernetes clients)."
  value       = aws_eks_cluster.this.certificate_authority[0].data
  sensitive   = true
}

output "configure_kubectl" {
  description = "Run this command to add the cluster to your local kubeconfig."
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.this.name}"
}
