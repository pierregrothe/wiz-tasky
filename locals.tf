// File: locals.tf
// Merges default and environment-specific tags for consistent tagging across modules

locals {
  // Merge default and environment-specific tags into a base map.
  base_tags = merge(
    var.tags_default, // Global default tags
    var.tags_env      // Environment-specific tags
  )

  // Final all_tags map includes the merged base_tags plus explicit project/environment tags,
  // and ensures "cost-center" is set from the merged base, defaulting to "CC-9999" if not provided.
  all_tags = merge(
    local.base_tags,
    {
      project       = var.project_name,
      environment   = var.environment,
      "cost-center" = lookup(local.base_tags, "cost-center", "CC-9999")
    }
  )
}
