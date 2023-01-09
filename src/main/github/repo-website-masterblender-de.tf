# Repository
# https://github.com/sebastian-sommerfeld-io/website-masterblender-de

data "github_repository" "website-masterblender-de" {
  full_name = "sebastian-sommerfeld-io/website-masterblender-de"
}

module "website-masterblender-de-issues" {
  source    = "./modules/issues"
  repo_name = data.github_repository.website-masterblender-de.id
}

module "website-masterblender-de-docker-pipelines" {
  source     = "./modules/docker-pipelines"
  repo_name  = data.github_repository.website-masterblender-de.id
  image_name = "sommerfeldio/website-masterblender-de"
  image_tag  = "latest"
  dockerfile = "Dockerfile"
}

resource "github_actions_secret" "website-masterblender-de_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.website-masterblender-de.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "website-masterblender-de_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.website-masterblender-de.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}

resource "github_actions_secret" "website-masterblender-de_SNYK_TOKEN" {
  repository      = data.github_repository.website-masterblender-de.id
  secret_name     = data.bitwarden_item_login.SNYK_TOKEN.username
  plaintext_value = data.bitwarden_item_login.SNYK_TOKEN.password
}

resource "github_actions_secret" "website-masterblender-de_DOCKERHUB_USER" {
  repository      = data.github_repository.website-masterblender-de.id
  secret_name     = data.bitwarden_item_login.DOCKERHUB_USER.username
  plaintext_value = data.bitwarden_item_login.DOCKERHUB_USER.password
}

data "bitwarden_item_login" "website-masterblender-de_DOCKERHUB_TOKEN" {
  id = "a098fee1-0676-4ea6-8e6a-af7100d146c0"
}
resource "github_actions_secret" "website-masterblender-de_DOCKERHUB_TOKEN" {
  repository      = data.github_repository.website-masterblender-de.id
  secret_name     = data.bitwarden_item_login.website-masterblender-de_DOCKERHUB_TOKEN.username
  plaintext_value = data.bitwarden_item_login.website-masterblender-de_DOCKERHUB_TOKEN.password
}

data "bitwarden_item_login" "website-masterblender-de_FTP_USER" {
  id = "0bd74b2a-dd81-438f-8095-af7100cd7c3c"
}
resource "github_actions_secret" "website-masterblender-de_FTP_USER" {
  repository      = data.github_repository.website-masterblender-de.id
  secret_name     = data.bitwarden_item_login.website-masterblender-de_FTP_USER.username
  plaintext_value = data.bitwarden_item_login.website-masterblender-de_FTP_USER.password
}

data "bitwarden_item_login" "website-masterblender-de_FTP_PASS" {
  id = "8ecc32f5-a9d7-4dbc-bb3a-af7100cd906e"
}
resource "github_actions_secret" "website-masterblender-de_FTP_PASS" {
  repository      = data.github_repository.website-masterblender-de.id
  secret_name     = data.bitwarden_item_login.website-masterblender-de_FTP_PASS.username
  plaintext_value = data.bitwarden_item_login.website-masterblender-de_FTP_PASS.password
}
