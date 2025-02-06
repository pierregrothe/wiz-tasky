// File: main.tf
// ---------------------------------------------------------------------------
// Root Module for the wiz-tasky Project
//
// This configuration orchestrates the deployment of all major components:
//   1. VPC: Creates the VPC, subnets, NAT Gateway, route tables, and the
//      necessary VPC endpoints for SSM and related services.
//   2. Bastion: Deploys a Bastion host (only in non-production environments)
//      to serve as a jump box.
//   3. S3 Backup: Provisions an S3 bucket for backups with conditional policies.
//   4. IAM: Uses a generic IAM module to create dedicated IAM roles for both
//      the Bastion and MongoDB instances. The role names are computed dynamically
//      using the project and environment values.
//   5. MongoDB: Launches an EC2 instance running MongoDB 8.x, configured
//      via an external user data script, with SSM enabled.
// ---------------------------------------------------------------------------

//
// VPC Module
// Deploys the VPC and networking components with dynamic naming.
//
module "vpc" {
  source               = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = var.availability_zones

  // Derive dynamic names from merged tags.
  project_name     = local.merged_tags["project"]
  environment_name = local.merged_tags["environment"]

  tags = local.merged_tags
}

//
// Bastion Module
// Deploys a Bastion host for remote access. This module is only deployed
// in non-production environments (dev and staging). It uses the first public
// subnet from the VPC module.
// Note: Ensure that the Bastion module's outputs reference the correct resource
// names (e.g., aws_instance.bastion_instance.id).
//
module "bastion" {
  // Only deploy Bastion if the environment is not "prod"
  count = var.environment == "prod" ? 0 : 1

  source = "./modules/bastion"

  vpc_id           = module.vpc.vpc_id
  public_subnet_id = element(module.vpc.public_subnets, 0)

  bastion_instance_type = var.bastion_instance_type
  ami_id                = var.bastion_ami_id
  // Allowed SSH IPs should be provided as a list.
  allowed_ssh_ips       = [var.bastion_allowed_ssh_ip]

  project_name     = local.merged_tags["project"]
  environment_name = local.merged_tags["environment"]
  tags             = local.merged_tags

  // Additional variable for Bastion if required by the module.
  bastion_allowed_ssh_ip = var.bastion_allowed_ssh_ip
}

//
// S3 Backup Module
// Provisions an S3 bucket for backups. The bucket name is dynamically constructed
// using the project and environment values.
// ---------------------------------------------------------------------------
module "s3_backup" {
  source           = "./modules/s3-backup"
  bucket_name      = "${var.project}-${var.environment}-backups"
  remediation_mode = var.remediation_mode
  tags             = local.merged_tags
  project_name     = local.merged_tags["project"]
  environment_name = local.merged_tags["environment"]
}

//
// Generic IAM Module for Bastion Host
// Creates a dedicated IAM role for the Bastion host. This module is only deployed
// in non-production environments. Role naming is computed dynamically based on
// project, environment, and role type (set to "bastion").
// ---------------------------------------------------------------------------
module "iam_bastion" {
  count = var.environment == "prod" ? 0 : 1

  source              = "./modules/iam"
  assumed_by_service  = "ec2.amazonaws.com"
  managed_policy_arns = {
    ssm = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  // No inline policy needed for Bastion, so this is an empty string.
  inline_policy_file  = ""
  tags                = local.merged_tags
  project_name        = local.merged_tags["project"]
  environment_name    = local.merged_tags["environment"]
  role_type           = "bastion"
}

//
// Generic IAM Module for MongoDB Instance
// Creates a dedicated IAM role for the MongoDB instance. The inline policy file
// is chosen based on the remediation_mode flag, switching between a remediated and
// a misconfigured policy.
// ---------------------------------------------------------------------------
module "iam_mongodb" {
  source              = "./modules/iam"
  assumed_by_service  = "ec2.amazonaws.com"
  managed_policy_arns = {
    ssm = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  inline_policy_file  = var.remediation_mode ? "${path.module}/modules/mongodb/iam_policy_remediated.json" : "${path.module}/modules/mongodb/iam_policy_misconfigured.json"
  tags                = local.merged_tags
  project_name        = local.merged_tags["project"]
  environment_name    = local.merged_tags["environment"]
  role_type           = "mongodb"
}

//
// MongoDB Module
// Deploys an EC2 instance running MongoDB. It receives its networking
// configuration from the VPC module, uses an instance profile associated with
// the IAM role from the iam_mongodb module, and passes admin credentials.
// ---------------------------------------------------------------------------
module "mongodb" {
  source                = "./modules/mongodb"
  vpc_id                = module.vpc.vpc_id
  private_subnet_id     = element(module.vpc.private_subnets, 0)
  instance_type         = var.mongodb_instance_type
  ami_id                = var.mongodb_ami_id
  remediation_mode      = var.remediation_mode
  mongodb_admin_username = var.mongodb_admin_username
  mongodb_admin_password = var.mongodb_admin_password
  tags                  = local.merged_tags
  project_name          = local.merged_tags["project"]
  environment_name      = local.merged_tags["environment"]
  vpc_cidr              = module.vpc.vpc_cidr
  mongodb_iam_role_name = module.iam_mongodb.role_name
}