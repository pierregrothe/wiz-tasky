// File: modules/mongodb/main.tf
// ---------------------------------------------------------------------------
// MongoDB Module for wiz-tasky Project
//
// This module provisions an EC2 instance configured to run MongoDB 8.x.
// It creates a security group with conditional ingress rules based on the
// remediation_mode flag, reads an external setup script (mongodb_setup.sh)
// to install and configure MongoDB, and launches the instance with the
// appropriate IAM instance profile (for SSM access).
// Resource names are dynamically constructed using the project and environment
// values passed in as variables.
// ---------------------------------------------------------------------------

/*
  Security Group: mongodb_sg
  Purpose:
    - Provides network access rules for the MongoDB instance.
    - In misconfigured mode (remediation_mode=false), the ingress rules allow
      public access; in remediated mode (remediation_mode=true), they restrict access to the VPC.
    - The group is named using the dynamic pattern: 
        <project_name>-<environment_name>-mongodb-sg
*/
resource "aws_security_group" "mongodb_sg" {
  name        = "${var.project_name}-${var.environment_name}-mongodb-sg"
  description = "Security group for MongoDB EC2 instance"
  vpc_id      = var.vpc_id

  // Allow SSH access
  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.remediation_mode ? [var.vpc_cidr] : ["0.0.0.0/0"]
  }

  // Allow MongoDB access on port 27017
  ingress {
    description = "Allow MongoDB access on port 27017"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = var.remediation_mode ? [var.vpc_cidr] : ["0.0.0.0/0"]
  }

  // Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name      = "${var.project_name}-${var.environment_name}-mongodb-sg",
      component = "mongodb"
    }
  )
}

/*
  IAM Instance Profile for MongoDB:
  Purpose:
    - Associates the MongoDB EC2 instance with an IAM role (created in the IAM module).
    - The instance profile is named using the pattern:
        <project_name>-<environment_name>-mongodb-profile
*/
resource "aws_iam_instance_profile" "mongodb_profile" {
  name = "${var.project_name}-${var.environment_name}-mongodb-profile"
  role = var.mongodb_iam_role_name
}

/*
  Template Data Source: mongodb_setup
  Purpose:
    - Reads the external MongoDB setup script (mongodb_setup.sh) and injects
      the MongoDB admin username and password.
    - This script should include the installation and configuration logic for MongoDB.
*/
data "template_file" "mongodb_setup" {
  template = file("${path.module}/mongodb_setup.sh")
  vars = {
    mongodb_admin_username = var.mongodb_admin_username
    mongodb_admin_password = var.mongodb_admin_password
  }
}


/*
  MongoDB EC2 Instance:
  Purpose:
    - Launches an EC2 instance to run MongoDB 8.x.
    - The instance is launched in a private subnet, uses the specified key pair,
      and is associated with the IAM instance profile for SSM access.
    - The instance's user_data is generated from the external setup script.
    - Tags are applied using dynamic naming to include the project and environment.
*/
resource "aws_instance" "mongodb_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  key_name                    = aws_key_pair.mongodb.key_name  // Ensure this resource is defined or passed in.
  iam_instance_profile        = aws_iam_instance_profile.mongodb_profile.name
  associate_public_ip_address = false

  vpc_security_group_ids = [aws_security_group.mongodb_sg.id]

  user_data = data.template_file.mongodb_setup.rendered

  tags = merge(
    var.tags,
    {
      Name      = "${var.project_name}-${var.environment_name}-mongodb",
      component = "mongodb"
    }
  )
}
