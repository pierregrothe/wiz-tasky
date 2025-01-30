# wiz-tasky/variables.tf
variable "aws_region" {
  description = "AWS region for deploying infrastructure"
  type        = string
  default     = "us-east-1"
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

variable "public_subnets_cidr" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "environment_name" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "tags_env" {
  description = "Environment-specific tags"
  type        = map(string)
  default     = {}
}

variable "tags_default" {
  description = "Default tags applied to all resources"
  type        = map(string)
  default     = {}
}

variable "mongodb_admin_username" {
  description = "MongoDB admin username"
  type        = string
}

variable "mongodb_admin_password" {
  description = "MongoDB admin password (sensitive variable)"
  type        = string
  sensitive   = true
}

variable "eks_version" {
  description = "EKS cluster version"
  type        = string
}
