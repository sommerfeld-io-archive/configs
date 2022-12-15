terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

# To authenticate using OAuth tokens, ensure that the `token` argument or
# the `GITHUB_TOKEN` environment variable is set.
provider "github" {
  #token = var.token # or `GITHUB_TOKEN`
}
