// File: modules/s3-backup/variables.tf
// ---------------------------------------------------------------------------
// Input Variables for the S3 Backup Module
// ---------------------------------------------------------------------------

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket for database backups."
}

variable "remediation_mode" {
  type        = bool
  description = "Toggle for remediation mode: true for a remediated (secure) configuration, false for misconfigured (public) configuration."
}

variable "tags" {
  type        = map(string)
  description = "Base tags to apply to the S3 bucket."
}

variable "project_name" {
  type        = string
  description = "Project name for resource naming and tagging."
}

variable "environment_name" {
  type        = string
  description = "Deployment environment (e.g., dev, staging, prod)."
}
