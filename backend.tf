terraform {
  backend "remote" {
    organization = "your-org-name"

    workspaces {
      name = "wiz-tasky-prod"
    }
  }
}
