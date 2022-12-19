# Repository
# https://github.com/sebastian-sommerfeld-io/github-action-generate-readme

data "github_repository" "github-action-generate-readme" {
  full_name = "sebastian-sommerfeld-io/github-action-generate-readme"
}

module "github-action-generate-readme-labels" {
  source    = "./modules/issue-labels"
  repo_name = data.github_repository.github-action-generate-readme.id
}
