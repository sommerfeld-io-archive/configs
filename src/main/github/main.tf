terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.12.0"
    }
  }
}

provider "github" {
  # token = var.gh_token
}

module "repo-config" {
  source = "./modules/repos/sebastian-sommerfeld-io/configs"
}

module "repo-trashbox" {
  source = "./modules/repos/sebastian-sommerfeld-io/trashbox"
}
