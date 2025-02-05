# Bastion Host Module for wiz-tasky Project

This module provisions a Bastion host to allow remote SSH access for troubleshooting in the deployed environment.

## Features

- **EC2 Bastion Host:** Deploys an EC2 instance using a specified AMI and instance type.
- **Security Group:** Creates a dedicated security group that allows SSH access only from allowed IP addresses.
- **Outputs:** Exposes the Bastion host's instance ID and public IP address.

## Inputs

- **vpc_id:** The ID of the VPC where the Bastion host will be deployed.
- **public_subnet_id:** The ID of the public subnet in which to deploy the Bastion host.
- **bastion_instance_type:** The EC2 instance type for the Bastion host (default: t3.micro).
- **ami_id:** The AMI ID for the Bastion host (default: ami-018875e7376831abe).
- **bastion_key_name:** The name of the SSH key pair to use for accessing the Bastion host.
- **allowed_ssh_ips:** A list of CIDR blocks allowed to SSH into the Bastion host.
- **project_name:** Project name for resource naming.
- **environment_name:** Deployment environment (dev, staging, prod).
- **tags:** Base tags to apply to all resources in this module.

## Outputs

- **bastion_instance_id:** The ID of the Bastion host instance.
- **bastion_public_ip:** The public IP address of the Bastion host.

## Usage Example

```hcl
module "bastion" {
  source             = "./modules/bastion"
  vpc_id             = module.vpc.vpc_id
  public_subnet_id   = element(module.vpc.public_subnets, 0)
  bastion_instance_type = "t3.micro"
  ami_id             = "ami-018875e7376831abe"
  bastion_key_name   = "your-key-name"
  allowed_ssh_ips    = ["203.0.113.0/24"]  // Replace with your allowed IP range
  project_name       = var.project
  environment_name   = var.environment
  tags               = local.all_tags
}
