// File: main.tf
// Root module for the wiz-tasky project, instantiates the VPC module

terraform {
  required_version = ">= 1.0.0"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = var.availability_zones

  project_name     = var.project
  environment_name = var.environment

  tags = local.all_tags
}

module "bastion" {
  source = "./modules/bastion"

  # Required inputs for Bastion module
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = element(module.vpc.public_subnets, 0)  // Use the first public subnet

  bastion_instance_type = var.bastion_instance_type
  ami_id                = var.bastion_ami_id
  bastion_key_name      = var.bastion_key_name
  allowed_ssh_ips       = var.allowed_ssh_ips

  project_name     = var.project
  environment_name = var.environment
  tags             = local.all_tags
}

