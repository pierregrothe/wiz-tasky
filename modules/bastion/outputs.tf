// File: modules/bastion/outputs.tf
// ---------------------------------------------------------------------------
// Outputs for the Bastion Module
// Exposes the Bastion host instance ID and its public IP address for remote access.
// ---------------------------------------------------------------------------

output "bastion_instance_id" {
  description = "The ID of the Bastion host instance."
  value       = aws_instance.bastion.id
}

output "bastion_public_ip" {
  description = "The public IP address of the Bastion host."
  value       = aws_instance.bastion.public_ip
}

output "bastion_private_key" {
  description = "The private key for the Bastion host. Download and store it securely."
  value       = tls_private_key.bastion.private_key_pem
  sensitive   = true
}
