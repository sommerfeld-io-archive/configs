# Repository
# https://github.com/sebastian-sommerfeld-io/jiracli

data "github_repository" "jiracli" {
  full_name = "sebastian-sommerfeld-io/jiracli"
}

module "jiracli-docker-pipelines" {
  source     = "./modules/docker-pipelines"
  repo_name  = data.github_repository.jiracli.id
  image_name = "sommerfeldio/jiracli"
  image_tag  = "latest"
  dockerfile = "src/main/Dockerfile"
}

module "jiracli-issues" {
  source       = "./modules/issues"
  repo_name    = data.github_repository.jiracli.id
  project      = "https://github.com/users/sebastian-sommerfeld-io/projects/2"
  issue_labels = "'task', '19+1'"
}

resource "github_issue_label" "jiracli_19_1" {
  repository  = data.github_repository.jiracli.id
  name        = "19+1"
  description = "Education and trainings (leaning by doing)"
  color       = "5319E7"
}

resource "github_actions_secret" "jiracli_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.jiracli.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "jiracli_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.jiracli.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}

resource "github_actions_secret" "jiracli_SNYK_TOKEN" {
  repository      = data.github_repository.jiracli.id
  secret_name     = data.bitwarden_item_login.SNYK_TOKEN.username
  plaintext_value = data.bitwarden_item_login.SNYK_TOKEN.password
}

resource "github_actions_secret" "jiracli_DOCKERHUB_USER" {
  repository      = data.github_repository.jiracli.id
  secret_name     = data.bitwarden_item_login.DOCKERHUB_USER.username
  plaintext_value = data.bitwarden_item_login.DOCKERHUB_USER.password
}

data "bitwarden_item_login" "jiracli_DOCKERHUB_TOKEN" {
  id = "4697a1d1-8300-4197-ac15-af8f00d4b8bc"
}
resource "github_actions_secret" "jiracli_DOCKERHUB_TOKEN" {
  repository      = data.github_repository.jiracli.id
  secret_name     = data.bitwarden_item_login.jiracli_DOCKERHUB_TOKEN.username
  plaintext_value = data.bitwarden_item_login.jiracli_DOCKERHUB_TOKEN.password
}

data "bitwarden_item_login" "jiracli_SONARCLOUD_TOKEN" {
  id = "9a961169-6655-4634-bc26-af8c00ff7971"
}
resource "github_actions_secret" "jiracli_SONARCLOUD_TOKEN" {
  repository      = data.github_repository.jiracli.id
  secret_name     = data.bitwarden_item_login.jiracli_SONARCLOUD_TOKEN.username
  plaintext_value = data.bitwarden_item_login.jiracli_SONARCLOUD_TOKEN.password
}
