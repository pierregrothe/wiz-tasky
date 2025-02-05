// File: locals.tf
// Merges default and environment-specific tags for consistent tagging across modules

locals {
  all_tags = merge(
    var.tags_default,  // Global default tags
    var.tags_env,      // Environment-specific tags
    {
      project     = var.project,         // Explicit project tag
      environment = var.environment,     // Explicit environment tag
      "cost-center" = lookup(var.tags_env, "cost-center", "CC-9999") // Default cost-center value if not provided
    }
  )
}
