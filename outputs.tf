// File: outputs.tf
// ---------------------------------------------------------------------------
// Root Outputs for the wiz-tasky Project
// Exposes key outputs from the modules for reference.
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
  description = "The ID of the Bastion host instance."
  value       = module.bastion.bastion_instance_id
}

output "bastion_public_ip" {
  description = "The public IP address of the Bastion host."
  value       = module.bastion.bastion_public_ip
}

output "bastion_role_arn" {
  description = "The ARN of the Bastion IAM role."
  value       = module.iam_bastion.role_arn
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