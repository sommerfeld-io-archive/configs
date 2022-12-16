# Repository
# https://github.com/sebastian-sommerfeld-io/docker-image-tf-graph-beautifier

data "github_repository" "docker-image-tf-graph-beautifier" {
  full_name = "sebastian-sommerfeld-io/docker-image-tf-graph-beautifier"
}

module "docker-image-tf-graph-beautifier-labels" {
  source    = "../../../issue-labels"
  repo_name = data.github_repository.docker-image-tf-graph-beautifier.id
}
