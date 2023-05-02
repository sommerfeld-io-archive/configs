# Repository
# https://github.com/sebastian-sommerfeld-io/open-appsec-poc

data "github_repository" "open-appsec-poc" {
  full_name = "sebastian-sommerfeld-io/open-appsec-poc"
}

module "open-appsec-poc-issues" {
  source    = "./modules/issues"
  repo_name = data.github_repository.open-appsec-poc.id
  project   = "https://github.com/users/sebastian-sommerfeld-io/projects/1"
}

resource "github_actions_secret" "open-appsec-poc_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.open-appsec-poc.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "open-appsec-poc_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.open-appsec-poc.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}
