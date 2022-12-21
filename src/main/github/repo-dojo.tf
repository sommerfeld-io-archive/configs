# Repository
# https://github.com/sebastian-sommerfeld-io/dojo

data "github_repository" "dojo" {
  full_name = "sebastian-sommerfeld-io/dojo"
}

module "dojo-labels" {
  source    = "./modules/issue-labels"
  repo_name = data.github_repository.dojo.id
}

resource "github_actions_secret" "dojo_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.dojo.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "dojo_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.dojo.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}

