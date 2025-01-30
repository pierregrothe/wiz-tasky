terraform {
  required_version = ">= 1.10.5"
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "wiz-interview-project"
    workspaces {
      name = "wiz-tasky-dev"
    }
  }
  

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84"
    }
  }
}

provider "aws" {
  region                  = var.aws_region
}
