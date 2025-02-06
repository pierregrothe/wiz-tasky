# MongoDB Module for wiz-tasky Project

This module deploys a Linux EC2 instance configured to run MongoDB. It includes:
- A security group that, based on the remediation_mode flag, either allows public access (misconfigured) or restricts access to the VPC.
- A user data script that installs MongoDB, creates an admin user with authentication enabled, and writes out a connection string.
- Outputs for the instance ID and the path to the connection string file.

## Inputs

- **vpc_id:** VPC in which to deploy the instance.
- **private_subnet_id:** Private subnet ID for deployment.
- **instance_type:** EC2 instance type (default: t3.micro).
- **ami_id:** AMI ID for the instance.
- **key_name:** Name of the EC2 key pair for SSH.
- **mongodb_admin_username:** MongoDB admin username.
- **mongodb_admin_password:** MongoDB admin password (sensitive).
- **remediation_mode:** Toggle for secure (true) or misconfigured (false) security group rules.
- **tags:** Base tags for resources.
- **project_name:** Project name for naming.
- **environment_name:** Deployment environment (e.g., dev, staging, prod).

## Outputs

- **mongodb_instance_id:** The EC2 instance ID.
- **mongodb_connection_string_file:** The file path on the instance containing the MongoDB connection string.

## Usage Example

```hcl
module "mongodb" {
  source             = "./modules/mongodb"
  vpc_id             = module.vpc.vpc_id
  private_subnet_id  = element(module.vpc.private_subnets, 0)
  instance_type      = "t3.micro"
  ami_id             = var.mongodb_ami_id
  key_name           = var.key_name
  mongodb_admin_username = var.mongodb_admin_username
  mongodb_admin_password = var.mongodb_admin_password
  remediation_mode   = var.remediation_mode
  tags               = local.all_tags
  project_name       = var.project
  environment_name   = var.environment
}
