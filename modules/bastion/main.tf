// File: modules/bastion/main.tf
// ---------------------------------------------------------------------------
// Bastion Host Module for wiz-tasky Project
// This module provisions a Bastion host EC2 instance to allow remote SSH
// access for troubleshooting. It creates a dedicated security group that
// restricts SSH access to allowed IP addresses, deploys the Bastion host
// in a specified public subnet, and outputs key details.
// ---------------------------------------------------------------------------

/*
  Resource: aws_security_group.bastion_sg
  Description: Security group for the Bastion host, allowing inbound SSH
               access only from the allowed IP addresses and all outbound traffic.
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
               The instance uses the provided AMI, instance type, and key pair.
               It is associated with the Bastion security group for controlled SSH access.
*/
resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.bastion_instance_type
  subnet_id              = var.public_subnet_id
  key_name               = var.bastion_key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = merge(
    local.merged_tags,
    { Name = "${var.project_name}-${var.environment_name}-bastion" }
  )
}
