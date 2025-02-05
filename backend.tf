terraform {
  cloud {
    organization = "wiz-interview-project"

    workspaces {
      prefix = "wiz-tasky-"
    }
  }
}
