variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16" # Default VPC CIDR
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags to apply to all resources in this module"
  default = {
    Environment   = "dev" # Default environment tag
    Project       = "wiz-tasky"
    ManagedBy     = "Terraform"
  }
}

variable "environment_name" {
  type        = string
  description = "Name of the environment (e.g., dev, staging, prod)"
  default     = "dev" # Default environment name
}