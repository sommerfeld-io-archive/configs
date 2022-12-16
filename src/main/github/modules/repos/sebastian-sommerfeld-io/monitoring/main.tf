# Repository
# https://github.com/sebastian-sommerfeld-io/monitoring

data "github_repository" "monitoring" {
  full_name = "sebastian-sommerfeld-io/monitoring"
}

module "monitoring-labels" {
  source    = "../../../issue-labels"
  repo_name = data.github_repository.monitoring.id
}
