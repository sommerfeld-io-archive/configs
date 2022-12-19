# Repository
# https://github.com/sebastian-sommerfeld-io/docker-image-folderslint

data "github_repository" "docker-image-folderslint" {
  full_name = "sebastian-sommerfeld-io/docker-image-folderslint"
}

module "docker-image-folderslint-labels" {
  source    = "./modules/issue-labels"
  repo_name = data.github_repository.docker-image-folderslint.id
}
