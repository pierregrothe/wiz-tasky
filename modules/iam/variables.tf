// File: modules/iam/variables.tf
// ---------------------------------------------------------------------------
// Input Variables for the Generic IAM Module
// ---------------------------------------------------------------------------

variable "assumed_by_service" {
  type        = string
  description = "The AWS service allowed to assume this role (e.g., ec2.amazonaws.com)."
  default     = "ec2.amazonaws.com"
}

variable "managed_policy_arns" {
  type        = map(string)
  description = "A map of managed policy ARNs to attach to the role."
  default     = {}
}

variable "inline_policy_json" {
  type        = string
  description = "A custom inline policy in JSON format to attach to the role. Leave empty if not used."
  default     = ""
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

variable "inline_policy_file" {
  type        = string
  description = "Path to the inline policy JSON file. If provided, its contents will be used as the inline policy."
  default     = ""
}

variable "role_type" {
  type        = string
  description = "A label for the type of role (e.g., 'bastion', 'mongodb')."
  default     = ""
}