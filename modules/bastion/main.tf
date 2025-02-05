// File: modules/bastion/main.tf
// ---------------------------------------------------------------------------
// Bastion Host Module for wiz-tasky Project
// This module provisions a Bastion host EC2 instance to allow remote SSH
// access for troubleshooting. It creates a dedicated security group that
// restricts SSH access to allowed IP addresses, deploys the Bastion host
// in a specified public subnet, and outputs key details.
// It leverages an automatically generated key pair (see key_pair.tf) for SSH access.
// ---------------------------------------------------------------------------

/*
  Resource: aws_security_group.bastion_sg
  Description: Security group for the Bastion host, allowing inbound SSH
               access only from allowed IP addresses.
*/
resource "aws_security_group" "bastion_sg" {
  name        = "${var.project_name}-${var.environment_name}-bastion-sg"
  description = "Security group for Bastion host to allow SSH access"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH access from allowed IP addresses"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_ips
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.merged_tags
}

/*
  Resource: aws_instance.bastion
  Description: Provisions the Bastion host instance in the specified public subnet.
               The instance is associated with the Bastion security group and uses the
               automatically generated key pair for SSH access.
*/
resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.bastion_instance_type
  subnet_id              = var.public_subnet_id
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  key_name = aws_key_pair.bastion.key_name

  tags = merge(
    local.merged_tags,
    { Name = "${var.project_name}-${var.environment_name}-bastion" }
  )
}
