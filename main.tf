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
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = var.availability_zones

  // Derive dynamic names from merged tags.
  project_name     = local.all_tags["project"]
  environment_name = local.all_tags["environment"]

  tags = local.all_tags
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
  allowed_ssh_ips = [var.bastion_allowed_ssh_ip]

  project_name     = local.all_tags["project"]
  environment_name = local.all_tags["environment"]
  tags             = local.all_tags

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
  bucket_name      = "${local.all_tags["project"]}-${local.all_tags["environment"]}-backups"
  remediation_mode = var.remediation_mode
  tags             = local.all_tags
  project_name     = local.all_tags["project"]
  environment_name = local.all_tags["environment"]
}

//
// Generic IAM Module for Bastion Host
// Creates a dedicated IAM role for the Bastion host. This module is only deployed
// in non-production environments. Role naming is computed dynamically based on
// project, environment, and role type (set to "bastion").
// ---------------------------------------------------------------------------
module "iam_bastion" {
  count = var.environment == "prod" ? 0 : 1

  source             = "./modules/iam"
  assumed_by_service = "ec2.amazonaws.com"
  managed_policy_arns = {
    ssm = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  // No inline policy needed for Bastion, so this is an empty string.
  inline_policy_file = ""
  tags               = local.all_tags
  project_name       = local.all_tags["project"]
  environment_name   = local.all_tags["environment"]
  role_type          = "bastion"
}

//
// Generic IAM Module for EKS Cluster
// Dynamically creates a custom IAM role for the EKS cluster.
// The remediation_mode flag selects between a secure policy (AmazonEKSClusterPolicy)
// and a misconfigured (more permissive) policy (AdministratorAccess).
module "iam_eks_cluster" {
  source             = "./modules/iam"
  assumed_by_service = "eks.amazonaws.com"
  managed_policy_arns = {
    ssm                = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    eks_cluster_policy = var.remediation_mode ? "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" : "arn:aws:iam::aws:policy/AdministratorAccess"
  }
  inline_policy_file = var.remediation_mode ? "${path.module}/modules/eks/iam_policy_remediated.json" : "${path.module}/modules/eks/iam_policy_misconfigured.json"
  tags               = local.all_tags
  project_name       = local.all_tags["project"]
  environment_name   = local.all_tags["environment"]
  role_type          = "eks_cluster"
}

//
// Generic IAM Module for EKS Node Group
// Dynamically creates a custom IAM role for the EKS node group.
// This role is assumed by EC2 instances (the worker nodes) and attaches the necessary
// managed policies for running EKS worker nodes, including read-only access to ECR and 
// the Amazon EKS CNI Policy.
//
module "iam_eks_node" {
  source             = "./modules/iam"
  assumed_by_service = "ec2.amazonaws.com"
  managed_policy_arns = {
    eks_worker_node_policy = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    ecr_read_only_policy   = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    cni_policy             = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  }
  inline_policy_file = ""  # No inline policy provided for nodes; managed policies suffice.
  tags               = local.all_tags
  project_name       = local.all_tags["project"]
  environment_name   = local.all_tags["environment"]
  role_type          = "eks_node"
}


//
// Generic IAM Module for MongoDB Instance
// Creates a dedicated IAM role for the MongoDB instance. The inline policy file
// is chosen based on the remediation_mode flag, switching between a remediated and
// a misconfigured policy.
// ---------------------------------------------------------------------------
module "iam_mongodb" {
  source             = "./modules/iam"
  assumed_by_service = "ec2.amazonaws.com"
  managed_policy_arns = {
    ssm = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  inline_policy_file = var.remediation_mode ? "${path.module}/modules/mongodb/iam_policy_remediated.json" : "${path.module}/modules/mongodb/iam_policy_misconfigured.json"
  tags               = local.all_tags
  project_name       = local.all_tags["project"]
  environment_name   = local.all_tags["environment"]
  role_type          = "mongodb"
}

//
// MongoDB Module
// Deploys an EC2 instance running MongoDB. It receives its networking
// configuration from the VPC module, uses an instance profile associated with
// the IAM role from the iam_mongodb module, and passes admin credentials.
// ---------------------------------------------------------------------------
module "mongodb" {
  source                 = "./modules/mongodb"
  vpc_id                 = module.vpc.vpc_id
  private_subnet_id      = element(module.vpc.private_subnets, 0)
  instance_type          = var.mongodb_instance_type
  ami_id                 = var.mongodb_ami_id
  remediation_mode       = var.remediation_mode
  mongodb_admin_username = var.mongodb_admin_username
  mongodb_admin_password = var.mongodb_admin_password
  tags                   = local.all_tags
  project_name           = local.all_tags["project"]
  environment_name       = local.all_tags["environment"]
  vpc_cidr               = module.vpc.vpc_cidr
  mongodb_iam_role_name  = module.iam_mongodb.role_name
}

//
// EKS Module
// Deploys an EKS cluster with a managed node group. The cluster and node group
// names are generated dynamically using the project and environment values.
// ---------------------------------------------------------------------------
module "eks" {
  source            = "./modules/eks"
  project_name      = local.all_tags["project"]
  environment_name  = local.all_tags["environment"]
  tags              = local.all_tags
  subnet_ids        = module.vpc.public_subnets  // Deploy the cluster in public subnets.
  cluster_role_arn  = module.iam_eks_cluster.role_arn     // Custom IAM role for the cluster.
  node_role_arn     = module.iam_eks_node.role_arn       // Provided as a variable or created via another module.
  eks_version       = var.eks_version
  desired_size      = var.eks_desired_size
  min_size          = var.eks_min_size
  max_size          = var.eks_max_size
  instance_types    = var.eks_instance_types
}