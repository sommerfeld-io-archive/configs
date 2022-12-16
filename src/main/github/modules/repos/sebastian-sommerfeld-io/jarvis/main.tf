# Repository
# https://github.com/sebastian-sommerfeld-io/jarvis

data "github_repository" "jarvis" {
  full_name = "sebastian-sommerfeld-io/jarvis"
}

module "jarvis-labels" {
  source    = "../../../issue-labels"
  repo_name = data.github_repository.jarvis.id
}
