terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "wiz-interview-project"

    workspaces {
      prefix = "wiz-tasky-"
    }
  }
}