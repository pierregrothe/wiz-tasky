// File: backend.tf

terraform {
  cloud {
    organization = "wiz-interview-project"

    workspaces {
      name = "wiz-tasky-dev" // Default workspace; will be overridden by TF_WORKSPACE if set.
    }

  }
}
