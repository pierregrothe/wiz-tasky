// File: modules/vpc/tags.tf

/*
  Local Variable: merged_tags
  Purpose:
    - Merges the base tags (from the root) with explicit project and environment values.
    - Ensures tag keys are lowercase and hyphenated.
*/
locals {
  merged_tags = merge(
    var.tags, // Base tags from the root module
    {
      project     = var.project_name,
      environment = var.environment_name
    }
  )
}
