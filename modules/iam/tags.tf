// File: modules/iam/tags.tf
// ---------------------------------------------------------------------------
// Tagging Helper for the IAM Module
// This file defines a local variable that merges the base tags passed in via
// the "tags" variable with explicit project and environment tags.
// ---------------------------------------------------------------------------

locals {
  merged_tags = merge(
    var.tags,
    {
      project     = var.project_name,
      environment = var.environment_name
    }
  )
}
