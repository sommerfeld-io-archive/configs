# Repository
# https://github.com/sebastian-sommerfeld-io/dojo

data "github_repository" "dojo" {
  full_name = "sebastian-sommerfeld-io/dojo"
}

module "dojo-issues" {
  source    = "./modules/issues"
  repo_name = data.github_repository.dojo.id
  project   = "https://github.com/users/sebastian-sommerfeld-io/projects/1"
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

data "bitwarden_item_login" "dojo_SONARCLOUD_TOKEN" {
  id = "9a961169-6655-4634-bc26-af8c00ff7971"
}
resource "github_actions_secret" "dojo_SONARCLOUD_TOKEN" {
  repository      = data.github_repository.dojo.id
  secret_name     = data.bitwarden_item_login.dojo_SONARCLOUD_TOKEN.username
  plaintext_value = data.bitwarden_item_login.dojo_SONARCLOUD_TOKEN.password
}
