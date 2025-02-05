// File: outputs.tf
// Outputs from the root module

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

output "bastion_private_key" {
  description = "The private key for the Bastion host, from the Bastion module."
  value       = module.bastion.bastion_private_key
  sensitive   = true
}

output "iam_role_arn" {
  description = "The ARN of the IAM role created for the MongoDB instance (or other purpose)."
  value       = module.iam.role_arn
}

output "s3_bucket_name" {
  description = "The name of the S3 backup bucket."
  value       = module.s3_backup.bucket_name
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 backup bucket."
  value       = module.s3_backup.bucket_arn
}