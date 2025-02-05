// File: main.tf
// Root module for the wiz-tasky project, instantiates the VPC module

terraform {
  required_version = ">= 1.0.0"
}

module "vpc" {
  source = "./modules/vpc"  // Path to the VPC module

  // VPC settings
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = var.availability_zones

  // Naming inputs for the module
  project_name     = var.project
  environment_name = var.environment

  // Pass the merged tags for consistent tagging
  tags = local.all_tags
}
