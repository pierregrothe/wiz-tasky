# VPC Module for wiz-tasky Project

This module provisions a Virtual Private Cloud (VPC) with the following components:
- A primary VPC with a configurable CIDR block.
- Public subnets with an Internet Gateway.
- Private subnets with a NAT Gateway (using an Elastic IP) for outbound internet access.
- Route tables and route table associations for both public and private subnets.

## Inputs

- **vpc_cidr**: The CIDR block for the VPC.
- **public_subnets_cidr**: List of CIDR blocks for public subnets.
- **private_subnets_cidr**: List of CIDR blocks for private subnets.
- **availability_zones**: List of Availability Zones for subnet placement.
- **project_name**: Project name used for naming resources.
- **environment_name**: Deployment environment (dev, staging, prod).
- **tags**: Base tags to apply to all resources in the module.

## Outputs

- **vpc_id**: The ID of the created VPC.
- **public_subnets**: List of public subnet IDs.
- **private_subnets**: List of private subnet IDs.

## Usage Example

```hcl
module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr              = "10.0.0.0/16"
  public_subnets_cidr   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr  = ["10.0.101.0/24", "10.0.102.0/24"]
  availability_zones    = ["us-east-2a", "us-east-2b"]
  project_name          = var.project
  environment_name      = var.environment
  tags                  = local.all_tags  // Merged tags from the root module
}
