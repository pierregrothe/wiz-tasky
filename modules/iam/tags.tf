// File: modules/iam/tags.tf
// ---------------------------------------------------------------------------
// Tagging Helper for the Generic IAM Module
// This file defines a local variable 'merged_tags' that merges the provided base tags
// with additional project and environment tags.
// ---------------------------------------------------------------------------
locals {
  merged_tags = merge(
    var.tags,
    {
      project     = var.project_name,
      environment = var.environment_name
      role_type   = var.role_type
    }
  )
}
