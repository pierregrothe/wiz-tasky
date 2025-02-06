// File: main.tf
// Root module for the wiz-tasky project, instantiates the VPC module

terraform {
  required_version = ">= 1.10.5"
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

  vpc_id           = module.vpc.vpc_id
  public_subnet_id = element(module.vpc.public_subnets, 0)

  bastion_instance_type = var.bastion_instance_type
  ami_id                = var.bastion_ami_id
  allowed_ssh_ips       = [var.bastion_allowed_ssh_ip] # if your module expects a list; otherwise, update the module to use a single string.

  project_name     = var.project
  environment_name = var.environment
  tags             = local.all_tags

  bastion_allowed_ssh_ip = var.bastion_allowed_ssh_ip
}

module "iam" {
  source            = "./modules/iam"
  role_name         = "wiz-tasky-mongodb-role"
  remediation_mode  = var.remediation_mode
  tags              = local.all_tags
  project_name      = var.project
  environment_name  = var.environment
}

module "s3_backup" {
  source           = "./modules/s3-backup"
  bucket_name      = "wiz-tasky-backups-${var.environment}"
  remediation_mode = var.remediation_mode
  tags             = local.all_tags
  project_name     = var.project
  environment_name = var.environment
}

module "mongodb" {
  source                = "./modules/mongodb"
  vpc_id                = module.vpc.vpc_id
  private_subnet_id     = element(module.vpc.private_subnets, 0)
  instance_type         = "t3.micro"
  ami_id                = var.mongodb_ami_id
  remediation_mode      = var.remediation_mode
  mongodb_admin_username = var.mongodb_admin_username
  mongodb_admin_password = var.mongodb_admin_password
  tags                  = local.all_tags
  project_name          = var.project
  environment_name      = var.environment
  vpc_cidr              = module.vpc.vpc_cidr
  mongodb_iam_role_name = module.iam.role_name
}
