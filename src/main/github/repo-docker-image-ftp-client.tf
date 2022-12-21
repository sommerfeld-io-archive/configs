# Repository
# https://github.com/sebastian-sommerfeld-io/docker-image-ftp-client

data "github_repository" "docker-image-ftp-client" {
  full_name = "sebastian-sommerfeld-io/docker-image-ftp-client"
}

module "docker-image-ftp-client-labels" {
  source    = "./modules/issue-labels"
  repo_name = data.github_repository.docker-image-ftp-client.id
}

resource "github_actions_secret" "docker-image-ftp-client_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.docker-image-ftp-client.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "docker-image-ftp-client_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.docker-image-ftp-client.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}

resource "github_actions_secret" "docker-image-ftp-client_SNYK_TOKEN" {
  repository      = data.github_repository.docker-image-ftp-client.id
  secret_name     = data.bitwarden_item_login.SNYK_TOKEN.username
  plaintext_value = data.bitwarden_item_login.SNYK_TOKEN.password
}

resource "github_actions_secret" "docker-image-ftp-client_DOCKERHUB_USER" {
  repository      = data.github_repository.docker-image-ftp-client.id
  secret_name     = data.bitwarden_item_login.DOCKERHUB_USER.username
  plaintext_value = data.bitwarden_item_login.DOCKERHUB_USER.password
}

data "bitwarden_item_login" "docker-image-ftp-client_DOCKERHUB_TOKEN" {
  id = "3e7cea74-bb38-4a16-88d1-af7100dd7ff3"
}
resource "github_actions_secret" "docker-image-ftp-client_DOCKERHUB_TOKEN" {
  repository      = data.github_repository.docker-image-ftp-client.id
  secret_name     = data.bitwarden_item_login.docker-image-ftp-client_DOCKERHUB_TOKEN.username
  plaintext_value = data.bitwarden_item_login.docker-image-ftp-client_DOCKERHUB_TOKEN.password
}
