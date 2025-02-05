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
