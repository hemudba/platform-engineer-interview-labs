# ── Project ───────────────────────────────────────────────────────────────────

variable "region" {
  type        = string
  description = "AWS region for VPC and EKS."
  default     = "us-east-2"
}

variable "project_name" {
  type        = string
  description = "Short name used in default_tags and resource naming."
  default     = "terraform-eks-lab"
}

# ── Cluster ───────────────────────────────────────────────────────────────────

variable "cluster_name" {
  type        = string
  description = "EKS cluster name; also used as a prefix for all related resources."
  default     = "lab1-eks"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes control plane version."
  default     = "1.29"
}

# ── Networking ────────────────────────────────────────────────────────────────

variable "vpc_cidr" {
  type        = string
  description = "IPv4 CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  type        = list(string)
  description = "CIDRs for public subnets. Must have the same length as private_subnets."
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDRs for private subnets (nodes and internal load balancers)."
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

# ── Node group ────────────────────────────────────────────────────────────────

variable "node_instance_type" {
  type        = string
  description = "EC2 instance type for the default node group."
  default     = "t3.medium"
}

variable "node_min_size" {
  type        = number
  description = "Minimum number of nodes in the default node group."
  default     = 1
}

variable "node_max_size" {
  type        = number
  description = "Maximum number of nodes in the default node group."
  default     = 2
}

variable "node_desired_size" {
  type        = number
  description = "Desired number of nodes in the default node group."
  default     = 1
}

# ── Misc ──────────────────────────────────────────────────────────────────────

variable "tags" {
  type        = map(string)
  description = "Extra tags merged into the provider default_tags block."
  default     = {}
}
