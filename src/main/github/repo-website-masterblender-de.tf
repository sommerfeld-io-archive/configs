# Repository
# https://github.com/sebastian-sommerfeld-io/website-masterblender-de

data "github_repository" "website-masterblender-de" {
  full_name = "sebastian-sommerfeld-io/website-masterblender-de"
}

module "website-masterblender-de-labels" {
  source    = "./modules/issue-labels"
  repo_name = data.github_repository.website-masterblender-de.id
}
