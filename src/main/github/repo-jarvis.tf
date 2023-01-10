# Repository
# https://github.com/sebastian-sommerfeld-io/jarvis

data "github_repository" "jarvis" {
  full_name = "sebastian-sommerfeld-io/jarvis"
}

module "jarvis-issues" {
  source    = "./modules/issues"
  repo_name = data.github_repository.jarvis.id
  project   = "https://github.com/users/sebastian-sommerfeld-io/projects/1"
}

resource "github_actions_secret" "jarvis_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.jarvis.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "jarvis_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.jarvis.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}

