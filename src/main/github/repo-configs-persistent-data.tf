# Repository
# https://github.com/sebastian-sommerfeld-io/configs-persistent-data

data "github_repository" "configs-persistent-data" {
  full_name = "sebastian-sommerfeld-io/configs-persistent-data"
}

module "configs-persistent-data-issues" {
  source    = "./modules/issues"
  repo_name = data.github_repository.configs-persistent-data.id
  project   = "https://github.com/users/sebastian-sommerfeld-io/projects/1"
}
