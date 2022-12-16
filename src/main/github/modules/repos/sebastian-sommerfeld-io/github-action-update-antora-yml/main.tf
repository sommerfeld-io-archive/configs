# Repository
# https://github.com/sebastian-sommerfeld-io/github-action-update-antora-yml

data "github_repository" "github-action-update-antora-yml" {
  full_name = "sebastian-sommerfeld-io/github-action-update-antora-yml"
}

module "github-action-update-antora-yml-labels" {
  source    = "../../../issue-labels"
  repo_name = data.github_repository.github-action-update-antora-yml.id
}
