# Repository
# https://github.com/sebastian-sommerfeld-io/docker-image-ftp-client

data "github_repository" "docker-image-ftp-client" {
  full_name = "sebastian-sommerfeld-io/docker-image-ftp-client"
}

module "docker-image-ftp-client-labels" {
  source    = "../../../issue-labels"
  repo_name = data.github_repository.docker-image-ftp-client.id
}
