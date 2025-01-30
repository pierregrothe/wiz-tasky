module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = var.availability_zones
  project_name         = var.project_name
  environment_name     = var.environment_name
  tags_default         = var.tags_default
  tags_env             = var.tags_env
}

/*
module "eks" {
  source            = "./modules/eks"
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  eks_version       = var.eks_version
  aws_role_arn      = var.aws_role_arn
  project_name      = var.project_name
  environment_name  = var.environment_name
  tags_default      = var.tags_default
  tags_env          = var.tags_env
}

module "iam" {
  source           = "./modules/iam"
  aws_account_id   = var.aws_account_id
  aws_role_arn     = var.aws_role_arn
  project_name     = var.project_name
  environment_name = var.environment_name
  tags_default     = var.tags_default
  tags_env         = var.tags_env
}

module "s3" {
  source           = "./modules/s3"
  project_name     = var.project_name
  environment_name = var.environment_name
  tags_default     = var.tags_default
  tags_env         = var.tags_env
}

module "oidc" {
  source         = "./modules/oidc"
  aws_account_id = var.aws_account_id
  project_name   = var.project_name
  environment_name = var.environment_name
}
*/