# Repository
# https://github.com/sebastian-sommerfeld-io/configs-persistent-data

data "github_repository" "configs-persistent-data" {
  full_name = "sebastian-sommerfeld-io/configs-persistent-data"
}

module "configs-persistent-data-labels" {
  source    = "./modules/issue-labels"
  repo_name = data.github_repository.configs-persistent-data.id
}
