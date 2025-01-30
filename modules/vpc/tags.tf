# wiz-tasky/modules/vpc/tags.tf

# Define a local variable to merge default, environment and project tags
locals {
  all_tags = merge(
    var.tags_default, # Default tags that apply to all resources
    var.tags_env,     # Environment-specific tags, which override defaults if there is a conflict
    {
      "Project" = var.project_name # Adds the project name tag
      "Environment" = var.environment_name # Adds the environment name tag
      "CostCenter"  = lookup(var.tags_env, "CostCenter", "WizProject") # Adds Cost Center if available
    }
  )
}