terraform {
  required_version = "1.3.6"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.12.0"
    }
  }
}

provider "github" {}

module "repo-config" {
  source = "./modules/repos/sebastian-sommerfeld-io/configs"
}

module "repo-trashbox" {
  source = "./modules/repos/sebastian-sommerfeld-io/trashbox"
}
