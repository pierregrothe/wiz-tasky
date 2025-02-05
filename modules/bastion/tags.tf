// File: modules/bastion/tags.tf
// ---------------------------------------------------------------------------
// Tagging Helper for the Bastion Module
// Merges the base tags passed from the root with explicit project and
// environment tags to ensure consistent tagging across resources.
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
