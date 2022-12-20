# Repository
# https://github.com/sebastian-sommerfeld-io/github-action-generate-docs

data "github_repository" "github-action-generate-docs" {
  full_name = "sebastian-sommerfeld-io/github-action-generate-docs"
}

module "github-action-generate-docs-labels" {
  source    = "./modules/issue-labels"
  repo_name = data.github_repository.github-action-generate-docs.id
}

resource "github_actions_secret" "github-action-generate-docs_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.github-action-generate-docs.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "github-action-generate-docs_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.github-action-generate-docs.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}
