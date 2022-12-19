# Repository
# https://github.com/sebastian-sommerfeld-io/docker-image-jq

data "github_repository" "docker-image-jq" {
  full_name = "sebastian-sommerfeld-io/docker-image-jq"
}

module "docker-image-jq-labels" {
  source    = "./modules/issue-labels"
  repo_name = data.github_repository.docker-image-jq.id
}
