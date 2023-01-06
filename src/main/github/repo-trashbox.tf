# Repository
# https://github.com/sebastian-sommerfeld-io/trashbox

data "github_repository" "trashbox" {
  full_name = "sebastian-sommerfeld-io/trashbox"
}

module "trashbox-issues" {
  source    = "./modules/issues"
  repo_name = data.github_repository.trashbox.id
}

resource "github_actions_secret" "trashbox_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.trashbox.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "trashbox_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.trashbox.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}

resource "github_actions_secret" "trashbox_EXAMPLE_FROM_TERRAFORM" {
  repository      = data.github_repository.trashbox.id
  secret_name     = "EXAMPLE_FROM_TERRAFORM"
  plaintext_value = "demo"
}
