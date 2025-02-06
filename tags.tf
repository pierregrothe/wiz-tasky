// File: tags.tf
/*
  Local Variable: merged_tags
  Purpose:
    - Merge the default tags (tags_default) and environment-specific tags (tags_env)
      provided by Terraform Cloud with explicit project and environment values.
    - This ensures that all resources receive both the pre-defined tags and
      dynamic keys for project and environment.
*/
locals {
  merged_tags = merge(
    var.tags_default,   // e.g., { "owner" = "pgrothe", "team" = "DevOps", "cost-center" = "CC-1234", "managed-by" = "Terraform" }
    var.tags_env,       // e.g., { "managed-by" = "Terraform" }
    {
      project     = var.project,       // Explicit project name provided separately
      environment = var.environment    // Explicit environment (dev/staging/prod) provided separately
    }
  )
}

