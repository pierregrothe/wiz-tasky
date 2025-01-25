terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  # Or specify the AWS provider version you want to use
    }
  }
}

provider "aws" {
  region = "us-east-2" # Replace with your desired AWS region (e.g., "us-east-1", "eu-west-1")
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = merge(
    var.default_tags,
    {
      Name = "${var.environment_name}-vpc"
    },
  )
}