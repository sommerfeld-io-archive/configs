# Repository
# https://github.com/sebastian-sommerfeld-io/docker-image-tf-graph-beautifier

data "github_repository" "docker-image-tf-graph-beautifier" {
  full_name = "sebastian-sommerfeld-io/docker-image-tf-graph-beautifier"
}

module "docker-image-tf-graph-beautifier-labels" {
  source    = "./modules/issue-labels"
  repo_name = data.github_repository.docker-image-tf-graph-beautifier.id
}

resource "github_actions_secret" "docker-image-tf-graph-beautifier_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.docker-image-tf-graph-beautifier.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "docker-image-tf-graph-beautifier_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.docker-image-tf-graph-beautifier.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}

resource "github_actions_secret" "docker-image-tf-graph-beautifier_SNYK_TOKEN" {
  repository      = data.github_repository.docker-image-tf-graph-beautifier.id
  secret_name     = data.bitwarden_item_login.SNYK_TOKEN.username
  plaintext_value = data.bitwarden_item_login.SNYK_TOKEN.password
}

resource "github_actions_secret" "docker-image-tf-graph-beautifier_DOCKERHUB_USER" {
  repository      = data.github_repository.docker-image-tf-graph-beautifier.id
  secret_name     = data.bitwarden_item_login.DOCKERHUB_USER.username
  plaintext_value = data.bitwarden_item_login.DOCKERHUB_USER.password
}

data "bitwarden_item_login" "docker-image-tf-graph-beautifier_DOCKERHUB_TOKEN" {
  id = "03cfc58b-bef7-4948-87cb-af7100ddec50"
}
resource "github_actions_secret" "docker-image-tf-graph-beautifier_DOCKERHUB_TOKEN" {
  repository      = data.github_repository.docker-image-tf-graph-beautifier.id
  secret_name     = data.bitwarden_item_login.docker-image-tf-graph-beautifier_DOCKERHUB_TOKEN.username
  plaintext_value = data.bitwarden_item_login.docker-image-tf-graph-beautifier_DOCKERHUB_TOKEN.password
}
