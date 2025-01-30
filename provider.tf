terraform {
  required_version = ">= 1.10.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84"
    }
  }
}

provider "aws" {
  region                  = var.aws_region
  profile                 = var.aws_profile
  allowed_account_ids      = [var.aws_account_id]

  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/github-actions-oidc"
    session_name = "github-actions"
  }
}
