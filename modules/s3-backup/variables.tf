// File: modules/s3-backup/variables.tf
// ---------------------------------------------------------------------------
// Input Variables for the S3 Backup Module for the wiz-tasky Project
//
// This module provisions an S3 bucket for storing database backups.
// The bucket name is expected to follow a dynamic naming convention (e.g.,
// <project>-<environment>-backups) that ensures uniqueness across environments.
// The remediation_mode flag controls whether a misconfigured (public) or
// remediated (secure) bucket policy is applied.
// ---------------------------------------------------------------------------

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket for database backups. It is recommended to use the naming convention: <project>-<environment>-backups."
}

variable "remediation_mode" {
  type        = bool
  description = "Toggle for remediation mode: set to true for a remediated (secure) configuration (public read access denied), or false for a misconfigured (public) configuration."
}

variable "tags" {
  type        = map(string)
  description = "A map of base tags to apply to the S3 bucket."
}

variable "project_name" {
  type        = string
  description = "The project name used for dynamic resource naming."
}

variable "environment_name" {
  type        = string
  description = "The deployment environment (e.g., dev, staging, prod) used for dynamic resource naming."
}
