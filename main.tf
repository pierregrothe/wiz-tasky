terraform {
  cloud {
    organization = "wiz-interview-project" # Your Terraform Cloud Organization name

    workspaces {
      prefix = "wiz-tasky-" # Workspace name prefix (e.g., wiz-tasky-dev, wiz-tasky-staging, wiz-tasky-prod)
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0" # Or your desired AWS provider version
    }
  }
}

provider "aws" {
  region = "us-east-2" # Your AWS Region (us-east-2)
}