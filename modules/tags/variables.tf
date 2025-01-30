variable "environment_name" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
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