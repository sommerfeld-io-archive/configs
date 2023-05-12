# Repository
# https://github.com/sebastian-sommerfeld-io/k8s-playground

data "github_repository" "k8s-playground" {
  full_name = "sebastian-sommerfeld-io/k8s-playground"
}

module "k8s-playground-issues" {
  source    = "./modules/issues"
  repo_name = data.github_repository.k8s-playground.id
  project   = "https://github.com/users/sebastian-sommerfeld-io/projects/2"
}

resource "github_issue_label" "k8s-playground_19_1" {
  repository  = data.github_repository.provinzial.id
  name        = "19+1"
  description = "Education and trainings (leaning by doing)"
  color       = "5319E7"
}

resource "github_actions_secret" "k8s-playground_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.k8s-playground.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "k8s-playground_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.k8s-playground.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}
