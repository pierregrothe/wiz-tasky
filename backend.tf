terraform {
  required_version = ">= 1.10.5"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "wiz-interview-project"

    workspaces {
      prefix = "wiz-tasky-${var.environment_name}"
    }
  }
}