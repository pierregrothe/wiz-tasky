// File: outputs.tf
// ---------------------------------------------------------------------------
// Root Outputs for the wiz-tasky Project
// These outputs provide key resource IDs from the modules.
// When using count on a module, the outputs are returned as a list.
// We index them to retrieve the first (and only) element in non-prod environments.
// ---------------------------------------------------------------------------

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "bastion_instance_id" {
  description = "The instance ID of the Bastion host (non-prod)."
  value       = var.environment == "prod" ? "Not Deployed" : module.bastion[0].bastion_instance_id
}

output "bastion_public_ip" {
  description = "The public IP of the Bastion host (non-prod)."
  value       = var.environment == "prod" ? "Not Deployed" : module.bastion[0].bastion_public_ip
}

output "bastion_role_arn" {
  description = "The ARN of the Bastion IAM role (non-prod)."
  value       = var.environment == "prod" ? "Not Deployed" : module.iam_bastion[0].role_arn
}

output "mongodb_role_arn" {
  description = "The ARN of the MongoDB IAM role."
  value       = module.iam_mongodb.role_arn
}

output "s3_bucket_name" {
  description = "The name of the S3 backup bucket."
  value       = module.s3_backup.bucket_name
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 backup bucket."
  value       = module.s3_backup.bucket_arn
}

output "mongodb_instance_id" {
  description = "The ID of the MongoDB EC2 instance."
  value       = module.mongodb.mongodb_instance_id
}

output "mongodb_connection_string_file" {
  description = "The file path on the MongoDB instance containing the connection string."
  value       = module.mongodb.mongodb_connection_string_file
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "The endpoint URL of the EKS cluster."
  value       = module.eks.cluster_endpoint
}