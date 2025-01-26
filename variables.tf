variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources in"
}

variable "environment_name" {
  type        = string
  description = "Name of the environment (e.g., dev, staging, prod)"
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags to apply to all resources"
}