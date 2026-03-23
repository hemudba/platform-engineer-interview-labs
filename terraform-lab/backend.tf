# Lab default: local state (terraform.tfstate in this directory).
#
# For remote state + locking, configure an S3 backend and DynamoDB table, then
# replace this block and run: terraform init -migrate-state
#
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "terraform-eks-lab/terraform.tfstate"
#     region         = "us-east-2"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }
