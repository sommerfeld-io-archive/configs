# Repository
# https://github.com/sebastian-sommerfeld-io/provinzial

data "github_repository" "provinzial" {
  full_name = "sebastian-sommerfeld-io/provinzial"
}

module "provinzial-issues" {
  source    = "./modules/issues"
  repo_name = data.github_repository.provinzial.id
}

resource "github_actions_secret" "provinzial_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.provinzial.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "provinzial_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.provinzial.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}

# Specific for this repository
resource "github_issue_label" "provinzial_19_1" {
  repository  = data.github_repository.provinzial.id
  name        = "19+1"
  description = "Education and trainings (leaning by doing)"
  color       = "5319E7"
}

resource "github_issue_label" "provinzial_training_certs" {
  repository  = data.github_repository.provinzial.id
  name        = "trainings / certificates"
  description = "External trainings"
  color       = "5319E7"
}
