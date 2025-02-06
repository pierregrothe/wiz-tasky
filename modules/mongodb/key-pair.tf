// File: modules/mongodb/key_pair.tf
// ---------------------------------------------------------------------------
// MongoDB Key Pair Generation Module
// This file generates a new RSA key pair for the MongoDB instance using the
// TLS provider and then creates an AWS Key Pair resource with that public key.
// The private key is output as sensitive so it can be downloaded and stored securely.
// This approach follows best practices by isolating credentials between layers.
// ---------------------------------------------------------------------------

resource "tls_private_key" "mongodb" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "mongodb" {
  key_name   = "${var.project_name}-${var.environment_name}-mongodb-key"
  public_key = tls_private_key.mongodb.public_key_openssh

  tags = merge(
    local.merged_tags,
    { Name = "${var.project_name}-${var.environment_name}-mongodb-key" }
  )
}

output "mongodb_private_key" {
  description = "The private key for the MongoDB instance. Download and store it securely."
  value       = tls_private_key.mongodb.private_key_pem
  sensitive   = true
}
