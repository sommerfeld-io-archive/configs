# Repository
# https://github.com/sebastian-sommerfeld-io/website-sommerfeld-io

data "github_repository" "website-sommerfeld-io" {
  full_name = "sebastian-sommerfeld-io/website-sommerfeld-io"
}

module "website-sommerfeld-io-labels" {
  source    = "./modules/issue-labels"
  repo_name = data.github_repository.website-sommerfeld-io.id
}
