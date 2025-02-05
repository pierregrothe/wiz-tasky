// File: variables.tf
// Global variables for the wiz-tasky project

variable "project" {
  type        = string
  description = "Project name (e.g., wiz-tasky)"
  default     = "wiz-tasky"
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev, staging, prod)"
  default     = "dev"
}

variable "aws_region" {
  type        = string
  description = "AWS region for deployment"
  default     = "us-east-2"
}

variable "assessment_mode" {
  type        = bool
  description = "Toggle for assessment mode (introduces intentional misconfigurations)"
  default     = false
}

variable "tags_default" {
  type = map(string)
  description = "Default tags for all resources"
  default = {
    project    = "wiz-tasky"
    managed_by = "Terraform"
  }
}

variable "tags_env" {
  type = map(string)
  description = "Environment-specific tags"
  default = {
    environment = "dev"
  }
}

// VPC configuration variables
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones for subnet placement"
  default     = ["us-east-2a", "us-east-2b"]
}
