// File: modules/iam/tags.tf
// ---------------------------------------------------------------------------
// Tagging Helper for the Generic IAM Module
// This file defines a local variable 'merged_tags' that merges the provided base tags
// with additional project and environment tags.
// ---------------------------------------------------------------------------
locals {
  // Compute a dynamic role name.
  computed_role_name = "${var.project_name}-${var.environment_name}-${var.role_type}-role"

  // Merge base tags with additional identification tags.
  merged_tags = merge(
    var.tags,
    {
      project     = var.project_name,
      environment = var.environment_name,
      role        = var.role_type
    }
  )
}
