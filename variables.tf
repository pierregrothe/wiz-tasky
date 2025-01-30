variable "aws_region" {
  description = "AWS region for deploying infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile (only used locally, not in CI/CD)"
  type        = string
  default     = "default"
}

variable "aws_account_id" {
  description = "AWS account ID where resources will be deployed"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "tags" {
  description = "Map of tags for all resources"
  type        = map(string)
}
