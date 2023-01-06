# Repository
# https://github.com/sebastian-sommerfeld-io/configs

data "github_repository" "configs" {
  full_name = "sebastian-sommerfeld-io/configs"
}

module "configs-issues" {
  source    = "./modules/issues"
  repo_name = data.github_repository.configs.id
}

resource "github_actions_secret" "configs_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.configs.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "configs_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.configs.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}
