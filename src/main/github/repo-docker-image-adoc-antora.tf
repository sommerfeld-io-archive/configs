# Repository
# https://github.com/sebastian-sommerfeld-io/docker-image-adoc-antora

data "github_repository" "docker-image-adoc-antora" {
  full_name = "sebastian-sommerfeld-io/docker-image-adoc-antora"
}

module "docker-image-adoc-antora-labels" {
  source    = "./modules/issue-labels"
  repo_name = data.github_repository.docker-image-adoc-antora.id
}
