# Repository
# https://github.com/sebastian-sommerfeld-io/docker-image-folderslint

data "github_repository" "docker-image-folderslint" {
  full_name = "sebastian-sommerfeld-io/docker-image-folderslint"
}

module "docker-image-folderslint-issues" {
  source    = "./modules/issues"
  repo_name = data.github_repository.docker-image-folderslint.id
  project   = "https://github.com/users/sebastian-sommerfeld-io/projects/1"
}

module "docker-image-folderslint-docker-pipelines" {
  source     = "./modules/docker-pipelines"
  repo_name  = data.github_repository.docker-image-folderslint.id
  image_name = "sommerfeldio/folderslint"
  image_tag  = "latest"
  dockerfile = "src/main/Dockerfile"
}

resource "github_actions_secret" "docker-image-folderslint_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.docker-image-folderslint.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "docker-image-folderslint_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.docker-image-folderslint.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}

resource "github_actions_secret" "docker-image-folderslint_SNYK_TOKEN" {
  repository      = data.github_repository.docker-image-folderslint.id
  secret_name     = data.bitwarden_item_login.SNYK_TOKEN.username
  plaintext_value = data.bitwarden_item_login.SNYK_TOKEN.password
}

resource "github_actions_secret" "docker-image-folderslint_DOCKERHUB_USER" {
  repository      = data.github_repository.docker-image-folderslint.id
  secret_name     = data.bitwarden_item_login.DOCKERHUB_USER.username
  plaintext_value = data.bitwarden_item_login.DOCKERHUB_USER.password
}

data "bitwarden_item_login" "docker-image-folderslint_DOCKERHUB_TOKEN" {
  id = "8bd7f6ab-6bf6-4302-912b-af7100dd55fd"
}
resource "github_actions_secret" "docker-image-folderslint_DOCKERHUB_TOKEN" {
  repository      = data.github_repository.docker-image-folderslint.id
  secret_name     = data.bitwarden_item_login.docker-image-folderslint_DOCKERHUB_TOKEN.username
  plaintext_value = data.bitwarden_item_login.docker-image-folderslint_DOCKERHUB_TOKEN.password
}
