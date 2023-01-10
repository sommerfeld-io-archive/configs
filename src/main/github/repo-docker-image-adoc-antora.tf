# Repository
# https://github.com/sebastian-sommerfeld-io/docker-image-adoc-antora

data "github_repository" "docker-image-adoc-antora" {
  full_name = "sebastian-sommerfeld-io/docker-image-adoc-antora"
}

module "docker-image-adoc-antora-issues" {
  source    = "./modules/issues"
  repo_name = data.github_repository.docker-image-adoc-antora.id
  project   = "https://github.com/users/sebastian-sommerfeld-io/projects/1"
}

module "docker-image-adoc-antora-docker-pipelines" {
  source     = "./modules/docker-pipelines"
  repo_name  = data.github_repository.docker-image-adoc-antora.id
  image_name = "sommerfeldio/adoc-antora"
  image_tag  = "latest"
  dockerfile = "src/main/Dockerfile"
}

resource "github_actions_secret" "docker-image-adoc-antora_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.docker-image-adoc-antora.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "docker-image-adoc-antora_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.docker-image-adoc-antora.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}

resource "github_actions_secret" "docker-image-adoc-antora_SNYK_TOKEN" {
  repository      = data.github_repository.docker-image-adoc-antora.id
  secret_name     = data.bitwarden_item_login.SNYK_TOKEN.username
  plaintext_value = data.bitwarden_item_login.SNYK_TOKEN.password
}

resource "github_actions_secret" "docker-image-adoc-antora_DOCKERHUB_USER" {
  repository      = data.github_repository.docker-image-adoc-antora.id
  secret_name     = data.bitwarden_item_login.DOCKERHUB_USER.username
  plaintext_value = data.bitwarden_item_login.DOCKERHUB_USER.password
}

data "bitwarden_item_login" "docker-image-adoc-antora_DOCKERHUB_TOKEN" {
  id = "7c3dcc0a-7c89-43cc-b4ec-af7100dd1c09"
}
resource "github_actions_secret" "docker-image-adoc-antora_DOCKERHUB_TOKEN" {
  repository      = data.github_repository.docker-image-adoc-antora.id
  secret_name     = data.bitwarden_item_login.docker-image-adoc-antora_DOCKERHUB_TOKEN.username
  plaintext_value = data.bitwarden_item_login.docker-image-adoc-antora_DOCKERHUB_TOKEN.password
}
