// File: modules/iam/generic/variables.tf
// ---------------------------------------------------------------------------
// Input Variables for the Generic IAM Module
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

variable "custom_policy_arns" {
  type        = map(string)
  description = "A map of custom policy ARNs to attach to the role (e.g., based on remediation mode)."
  default     = {}
}

variable "managed_policy_arns" {
  type        = map(string)
  description = "A map of managed policy ARNs to attach to the role (e.g., SSM policy)."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Base tags to apply to the IAM role."
  default     = {}
}

variable "project_name" {
  type        = string
  description = "Project name for resource naming and tagging."
}

variable "environment_name" {
  type        = string
  description = "Deployment environment (e.g., dev, staging, prod)."
}

variable "role_type" {
  type        = string
  description = "A label for the type of role (e.g., 'bastion', 'mongodb')."
  default     = ""
}
