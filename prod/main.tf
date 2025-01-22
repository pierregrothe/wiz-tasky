module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  cidr        = var.cidr_block
  azs         = var.availability_zones
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets

  tags = var.tags
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.6.0"

  name        = "tasky-sg"
  vpc_id      = module.vpc.vpc_id
  ingress_with_cidr_blocks = var.ingress_rules
  egress_with_cidr_blocks  = var.egress_rules

  tags = var.tags
}
