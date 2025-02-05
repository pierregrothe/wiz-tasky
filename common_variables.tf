// common_variables.tf

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
  description = "Toggle to enable intentional misconfigurations for assessment"
  default     = false
}

variable "tags_default" {
  type = map(string)
  description = "Default tags applied to all resources"
  default = {
    project    = "wiz-tasky"
    managed_by = "Terraform"
  }
}

variable "tags_env" {
  type = map(string)
  description = "Environment-specific tags"
  default = {
    environment = "dev"  // This can be overridden per environment
  }
}

locals {
  // Merge default and environment-specific tags, plus explicit project and environment tags
  all_tags = merge(
    var.tags_default,
    var.tags_env,
    {
      project     = var.project,
      environment = var.environment
    }
  )
}