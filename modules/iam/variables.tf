// File: modules/iam/variables.tf
// ---------------------------------------------------------------------------
// Input Variables for the IAM Module
// Define variables required to create the IAM role and its attached policy.
// ---------------------------------------------------------------------------

variable "role_name" {
  type        = string
  description = "The name for the IAM role."
}

variable "assumed_by_service" {
  type        = string
  description = "The AWS service allowed to assume this role (e.g., ec2.amazonaws.com)."
  default     = "ec2.amazonaws.com"
}

variable "assessment_mode" {
  type        = bool
  description = "Toggle to enable intentional misconfigurations (overly permissive policies) for assessment."
}

variable "tags" {
  type        = map(string)
  description = "Base tags to apply to the IAM role."
}

variable "project_name" {
  type        = string
  description = "Project name for resource naming and tagging."
}

variable "environment_name" {
  type        = string
  description = "Deployment environment (e.g., dev, staging, prod)."
}
