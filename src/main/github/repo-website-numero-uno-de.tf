# Repository
# https://github.com/sebastian-sommerfeld-io/website-numero-uno-de

data "github_repository" "website-numero-uno-de" {
  full_name = "sebastian-sommerfeld-io/website-numero-uno-de"
}

module "website-numero-uno-de-issues" {
  source    = "./modules/issues"
  repo_name = data.github_repository.website-numero-uno-de.id
}

resource "github_actions_secret" "website-numero-uno-de_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.website-numero-uno-de.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "website-numero-uno-de_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.website-numero-uno-de.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}

resource "github_actions_secret" "website-numero-uno-de_SNYK_TOKEN" {
  repository      = data.github_repository.website-numero-uno-de.id
  secret_name     = data.bitwarden_item_login.SNYK_TOKEN.username
  plaintext_value = data.bitwarden_item_login.SNYK_TOKEN.password
}

resource "github_actions_secret" "website-numero-uno-de_DOCKERHUB_USER" {
  repository      = data.github_repository.website-numero-uno-de.id
  secret_name     = data.bitwarden_item_login.DOCKERHUB_USER.username
  plaintext_value = data.bitwarden_item_login.DOCKERHUB_USER.password
}

data "bitwarden_item_login" "website-numero-uno-de_DOCKERHUB_TOKEN" {
  id = "d4a17f3c-9e98-48dd-be7e-af7100d4caed"
}
resource "github_actions_secret" "website-numero-uno-de_DOCKERHUB_TOKEN" {
  repository      = data.github_repository.website-numero-uno-de.id
  secret_name     = data.bitwarden_item_login.website-numero-uno-de_DOCKERHUB_TOKEN.username
  plaintext_value = data.bitwarden_item_login.website-numero-uno-de_DOCKERHUB_TOKEN.password
}

data "bitwarden_item_login" "website-numero-uno-de_FTP_USER" {
  id = "3604ef88-8d83-46d5-b306-af7100d64e51"
}
resource "github_actions_secret" "website-numero-uno-de_FTP_USER" {
  repository      = data.github_repository.website-numero-uno-de.id
  secret_name     = data.bitwarden_item_login.website-numero-uno-de_FTP_USER.username
  plaintext_value = data.bitwarden_item_login.website-numero-uno-de_FTP_USER.password
}

data "bitwarden_item_login" "website-numero-uno-de_FTP_PASS" {
  id = "acb31586-ffd5-4673-ae3a-af7100d637e4"
}
resource "github_actions_secret" "website-numero-uno-de_FTP_PASS" {
  repository      = data.github_repository.website-numero-uno-de.id
  secret_name     = data.bitwarden_item_login.website-numero-uno-de_FTP_PASS.username
  plaintext_value = data.bitwarden_item_login.website-numero-uno-de_FTP_PASS.password
}
