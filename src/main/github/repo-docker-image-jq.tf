# Repository
# https://github.com/sebastian-sommerfeld-io/docker-image-jq

data "github_repository" "docker-image-jq" {
  full_name = "sebastian-sommerfeld-io/docker-image-jq"
}

module "docker-image-jq-labels" {
  source    = "./modules/issue-labels"
  repo_name = data.github_repository.docker-image-jq.id
}

resource "github_actions_secret" "docker-image-jq_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.docker-image-jq.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "docker-image-jq_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.docker-image-jq.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}

resource "github_actions_secret" "docker-image-jq_SNYK_TOKEN" {
  repository      = data.github_repository.docker-image-jq.id
  secret_name     = data.bitwarden_item_login.SNYK_TOKEN.username
  plaintext_value = data.bitwarden_item_login.SNYK_TOKEN.password
}

resource "github_actions_secret" "docker-image-jq_DOCKERHUB_USER" {
  repository      = data.github_repository.docker-image-jq.id
  secret_name     = data.bitwarden_item_login.DOCKERHUB_USER.username
  plaintext_value = data.bitwarden_item_login.DOCKERHUB_USER.password
}

data "bitwarden_item_login" "docker-image-jq_DOCKERHUB_TOKEN" {
  id = "df918914-8664-46c6-9774-af7100ddce43"
}
resource "github_actions_secret" "docker-image-jq_DOCKERHUB_TOKEN" {
  repository      = data.github_repository.docker-image-jq.id
  secret_name     = data.bitwarden_item_login.docker-image-jq_DOCKERHUB_TOKEN.username
  plaintext_value = data.bitwarden_item_login.docker-image-jq_DOCKERHUB_TOKEN.password
}
