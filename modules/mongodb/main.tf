// File: modules/mongodb/main.tf
// ---------------------------------------------------------------------------
// MongoDB Module for wiz-tasky Project
// This module provisions an EC2 instance configured to run MongoDB.
// It uses a user data script to install and configure MongoDB (including
// enabling authentication) and creates a security group with rules that
// vary based on the remediation_mode flag.
// ---------------------------------------------------------------------------

# Create a security group for the MongoDB instance.
resource "aws_security_group" "mongodb_sg" {
  name        = "${var.project_name}-${var.environment_name}-mongodb-sg"
  description = "Security group for MongoDB EC2 instance"
  vpc_id      = var.vpc_id

  # SSH ingress rule.
  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # In misconfigured mode, allow from anywhere; if remediated, restrict to VPC.
    cidr_blocks = var.remediation_mode ? [var.vpc_cidr] : ["0.0.0.0/0"]
  }

  # MongoDB port (default 27017) ingress rule.
  ingress {
    description = "Allow MongoDB access"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    # In misconfigured mode, allow public access; if remediated, restrict to VPC.
    cidr_blocks = var.remediation_mode ? [var.vpc_cidr] : ["0.0.0.0/0"]
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

# Read the MongoDB setup script from an external file and replace placeholders.
data "template_file" "mongodb_setup" {
  template = file("${path.module}/mongodb_setup.sh")
  vars = {
    mongodb_admin_username = var.mongodb_admin_username
    mongodb_admin_password = var.mongodb_admin_password
  }
}


# Launch the MongoDB EC2 instance.
resource "aws_instance" "mongodb_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  key_name               = aws_key_pair.mongodb.key_name   // Updated to use MongoDB key pair
  associate_public_ip_address = false

  vpc_security_group_ids = [aws_security_group.mongodb_sg.id]

  user_data = data.template_file.mongodb_userdata.rendered

  tags = merge(
    local.merged_tags,
    { Name = "${var.project_name}-${var.environment_name}-mongodb" }
  )
}
