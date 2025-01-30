terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "wiz-tasky-org"

    workspaces {
      name = var.terraform_workspace
    }
  }
}
