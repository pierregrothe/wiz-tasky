// File: modules/mongodb/tags.tf
// ---------------------------------------------------------------------------
// Tagging Helper for the MongoDB Module
// This file defines a local variable that merges the base tags with explicit
// project and environment tags.
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
