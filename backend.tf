terraform {
  backend "remote" {
    organization = "3-tier"
    workspaces {
      prefix = "module"
    }
  }
}
