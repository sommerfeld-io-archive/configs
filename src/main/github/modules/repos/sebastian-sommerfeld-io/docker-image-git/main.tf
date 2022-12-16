# Repository
# https://github.com/sebastian-sommerfeld-io/docker-image-git

data "github_repository" "docker-image-git" {
  full_name = "sebastian-sommerfeld-io/docker-image-git"
}

module "docker-image-git-labels" {
  source    = "../../../issue-labels"
  repo_name = data.github_repository.docker-image-git.id
}
