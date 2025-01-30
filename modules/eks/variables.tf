variable "vpc_id" {
  description = "VPC ID where EKS will be deployed"
  type        = string
}

variable "project_name" {
  description = "Project name to use for tagging"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs where EKS nodes will be placed"
  type        = list(string)
}

variable "tags" {
  description = "Map of tags to assign to resources"
  type        = map(string)
  default     = {}
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