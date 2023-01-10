# Repository
# https://github.com/sebastian-sommerfeld-io/docker-image-git

data "github_repository" "docker-image-git" {
  full_name = "sebastian-sommerfeld-io/docker-image-git"
}

module "docker-image-git-issues" {
  source    = "./modules/issues"
  repo_name = data.github_repository.docker-image-git.id
  project   = "https://github.com/users/sebastian-sommerfeld-io/projects/1"
}

module "docker-image-git-docker-pipelines" {
  source     = "./modules/docker-pipelines"
  repo_name  = data.github_repository.docker-image-git.id
  image_name = "sommerfeldio/git"
  image_tag  = "latest"
  dockerfile = "src/main/Dockerfile"
}

resource "github_actions_secret" "docker-image-git_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.docker-image-git.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "docker-image-git_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.docker-image-git.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}

resource "github_actions_secret" "docker-image-git_SNYK_TOKEN" {
  repository      = data.github_repository.docker-image-git.id
  secret_name     = data.bitwarden_item_login.SNYK_TOKEN.username
  plaintext_value = data.bitwarden_item_login.SNYK_TOKEN.password
}

resource "github_actions_secret" "docker-image-git_DOCKERHUB_USER" {
  repository      = data.github_repository.docker-image-git.id
  secret_name     = data.bitwarden_item_login.DOCKERHUB_USER.username
  plaintext_value = data.bitwarden_item_login.DOCKERHUB_USER.password
}

data "bitwarden_item_login" "docker-image-git_DOCKERHUB_TOKEN" {
  id = "fc9177f7-b374-4885-91e9-af7100dda19b"
}
resource "github_actions_secret" "docker-image-git_DOCKERHUB_TOKEN" {
  repository      = data.github_repository.docker-image-git.id
  secret_name     = data.bitwarden_item_login.docker-image-git_DOCKERHUB_TOKEN.username
  plaintext_value = data.bitwarden_item_login.docker-image-git_DOCKERHUB_TOKEN.password
}
