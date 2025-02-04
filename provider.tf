terraform {
  required_version = ">= 1.10.5"
  cloud {
    organization = "wiz-interview-project"

    workspaces {
      prefix = "wiz-tasky-"
    }
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
