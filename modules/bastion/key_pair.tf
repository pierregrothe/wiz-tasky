// File: modules/bastion/key_pair.tf
// ---------------------------------------------------------------------------
// This file automatically generates an RSA key pair for the Bastion host.
// The private key is output as sensitive, so you can download and store it securely.
// ---------------------------------------------------------------------------

resource "tls_private_key" "bastion" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "bastion" {
  // Construct a unique key name using the project and environment names.
  key_name   = "${var.project_name}-${var.environment_name}-bastion-key"
  public_key = tls_private_key.bastion.public_key_openssh

  tags = merge(
    local.merged_tags,
    { Name = "${var.project_name}-${var.environment_name}-bastion-key" }
  )
}
