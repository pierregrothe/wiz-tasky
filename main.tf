module "vpc" {
  source               = "./modules/vpc"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  tags                 = var.tags
}

module "iam" {
  source = "./modules/iam"
}

module "eks" {
  source              = "./modules/eks"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids 
}



module "s3" {
  source = "./modules/s3"
}

module "oidc" {
  source = "./modules/oidc"
}

module "tags" {
  source = "./modules/tags"
}
