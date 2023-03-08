# Repository
# https://github.com/sebastian-sommerfeld-io/tron

data "github_repository" "tron" {
  full_name = "sebastian-sommerfeld-io/tron"
}

module "tron-docker-pipelines" {
  source     = "./modules/docker-pipelines"
  repo_name  = data.github_repository.tron.id
  image_name = "sommerfeldio/tron"
  image_tag  = "latest"
  dockerfile = "src/main/Dockerfile"
}

module "tron-issues" {
  source       = "./modules/issues"
  repo_name    = data.github_repository.tron.id
  project      = "https://github.com/users/sebastian-sommerfeld-io/projects/2"
  issue_labels = "'task', '19+1'"
}

resource "github_issue_label" "tron_19_1" {
  repository  = data.github_repository.tron.id
  name        = "19+1"
  description = "Education and trainings (leaning by doing)"
  color       = "5319E7"
}

resource "github_actions_secret" "tron_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.tron.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "tron_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.tron.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}

resource "github_actions_secret" "tron_SNYK_TOKEN" {
  repository      = data.github_repository.tron.id
  secret_name     = data.bitwarden_item_login.SNYK_TOKEN.username
  plaintext_value = data.bitwarden_item_login.SNYK_TOKEN.password
}

resource "github_actions_secret" "tron_DOCKERHUB_USER" {
  repository      = data.github_repository.tron.id
  secret_name     = data.bitwarden_item_login.DOCKERHUB_USER.username
  plaintext_value = data.bitwarden_item_login.DOCKERHUB_USER.password
}

data "bitwarden_item_login" "tron_DOCKERHUB_TOKEN" {
  id = "3f932bc6-81c7-46d6-891e-afbf013fb1ac"
}
resource "github_actions_secret" "tron_DOCKERHUB_TOKEN" {
  repository      = data.github_repository.tron.id
  secret_name     = data.bitwarden_item_login.tron_DOCKERHUB_TOKEN.username
  plaintext_value = data.bitwarden_item_login.tron_DOCKERHUB_TOKEN.password
}

data "bitwarden_item_login" "tron_SONARCLOUD_TOKEN" {
  id = "9a961169-6655-4634-bc26-af8c00ff7971"
}
resource "github_actions_secret" "tron_SONARCLOUD_TOKEN" {
  repository      = data.github_repository.tron.id
  secret_name     = data.bitwarden_item_login.tron_SONARCLOUD_TOKEN.username
  plaintext_value = data.bitwarden_item_login.tron_SONARCLOUD_TOKEN.password
}
