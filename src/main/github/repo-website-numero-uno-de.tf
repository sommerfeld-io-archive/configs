# Repository
# https://github.com/sebastian-sommerfeld-io/website-numero-uno-de

data "github_repository" "website-numero-uno-de" {
  full_name = "sebastian-sommerfeld-io/website-numero-uno-de"
}

module "website-numero-uno-de-labels" {
  source    = "./modules/issue-labels"
  repo_name = data.github_repository.website-numero-uno-de.id
}
