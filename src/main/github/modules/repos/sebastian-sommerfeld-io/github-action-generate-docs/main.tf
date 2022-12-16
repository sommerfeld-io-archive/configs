# Repository
# https://github.com/sebastian-sommerfeld-io/github-action-generate-docs

data "github_repository" "github-action-generate-docs" {
  full_name = "sebastian-sommerfeld-io/github-action-generate-docs"
}

module "github-action-generate-docs-labels" {
  source    = "../../../issue-labels"
  repo_name = data.github_repository.github-action-generate-docs.id
}
