# Repository
# https://github.com/sebastian-sommerfeld-io/website-tafelboy-de

data "github_repository" "website-tafelboy-de" {
  full_name = "sebastian-sommerfeld-io/website-tafelboy-de"
}

module "website-tafelboy-de-labels" {
  source    = "./modules/issue-labels"
  repo_name = data.github_repository.website-tafelboy-de.id
}
