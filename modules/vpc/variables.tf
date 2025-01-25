variable "environment_name" {
  type        = string
  description = "Name of the environment (e.g., dev, staging, prod)"
  default     = "dev"
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources in"
  default     = "us-east-2" # Default to us-east-2 for now
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16" # Default VPC CIDR
}

variable "public_subnet_cidr_a" {
  type        = string
  description = "CIDR block for Public Subnet in AZ-a"
  default     = "10.0.1.0/24" # Default Public Subnet CIDR for AZ-a
}

variable "public_subnet_cidr_b" {
  type        = string
  description = "CIDR block for Public Subnet in AZ-b"
  default     = "10.0.2.0/24" # Default Public Subnet CIDR for AZ-b
}

variable "private_subnet_cidr_a" {
  type        = string
  description = "CIDR block for Private Subnet in AZ-a"
  default     = "10.0.11.0/24" # Default Private Subnet CIDR for AZ-a
}

variable "private_subnet_cidr_b" {
  type        = string
  description = "CIDR block for Private Subnet in AZ-b"
  default     = "10.0.12.0/24" # Default Private Subnet CIDR for AZ-b
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Enable NAT Gateway for private subnets?"
  default     = true # Enable NAT Gateway by default
}

variable "single_nat_gateway" {
  type        = bool
  description = "Use a single NAT Gateway (cost-saving) or NAT Gateway per AZ (HA)?"
  default     = true # Single NAT Gateway for cost saving by default (for exercise)
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags to apply to all resources in this module"
  default = {
    Environment   = "dev" # Default environment tag - will be overridden by Variable Sets
    Project       = "wiz-tasky" # Project tag - will be overridden by Variable Sets
    ManagedBy     = "Terraform"
    Team          = "DevOps"     # Example of additional tag
    CostCenter    = "CC-1234"   # Example of additional tag
  }
}