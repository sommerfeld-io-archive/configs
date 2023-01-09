# Repository
# https://github.com/sebastian-sommerfeld-io/website-tafelboy-de

data "github_repository" "website-tafelboy-de" {
  full_name = "sebastian-sommerfeld-io/website-tafelboy-de"
}

module "website-tafelboy-de-issues" {
  source    = "./modules/issues"
  repo_name = data.github_repository.website-tafelboy-de.id
}

module "website-tafelboy-de-docker-pipelines" {
  source     = "./modules/docker-pipelines"
  repo_name  = data.github_repository.website-tafelboy-de.id
  image_name = "sommerfeldio/website-tafelboy-de"
  image_tag  = "latest"
  dockerfile = "Dockerfile"
}

resource "github_actions_secret" "website-tafelboy-de_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.website-tafelboy-de.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "website-tafelboy-de_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.website-tafelboy-de.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}

resource "github_actions_secret" "website-tafelboy-de_SNYK_TOKEN" {
  repository      = data.github_repository.website-tafelboy-de.id
  secret_name     = data.bitwarden_item_login.SNYK_TOKEN.username
  plaintext_value = data.bitwarden_item_login.SNYK_TOKEN.password
}

resource "github_actions_secret" "website-tafelboy-de_DOCKERHUB_USER" {
  repository      = data.github_repository.website-tafelboy-de.id
  secret_name     = data.bitwarden_item_login.DOCKERHUB_USER.username
  plaintext_value = data.bitwarden_item_login.DOCKERHUB_USER.password
}

data "bitwarden_item_login" "website-tafelboy-de_DOCKERHUB_TOKEN" {
  id = "b57cb72f-dc7e-4b80-b7d5-af7100d4f88f"
}
resource "github_actions_secret" "website-tafelboy-de_DOCKERHUB_TOKEN" {
  repository      = data.github_repository.website-tafelboy-de.id
  secret_name     = data.bitwarden_item_login.website-tafelboy-de_DOCKERHUB_TOKEN.username
  plaintext_value = data.bitwarden_item_login.website-tafelboy-de_DOCKERHUB_TOKEN.password
}

data "bitwarden_item_login" "website-tafelboy-de_FTP_USER" {
  id = "9e021a37-e076-4f74-a122-af7100d698fb"
}
resource "github_actions_secret" "website-tafelboy-de_FTP_USER" {
  repository      = data.github_repository.website-tafelboy-de.id
  secret_name     = data.bitwarden_item_login.website-tafelboy-de_FTP_USER.username
  plaintext_value = data.bitwarden_item_login.website-tafelboy-de_FTP_USER.password
}

data "bitwarden_item_login" "website-tafelboy-de_FTP_PASS" {
  id = "af66f5f9-bd54-4c3c-8f7c-af7100d684ca"
}
resource "github_actions_secret" "website-tafelboy-de_FTP_PASS" {
  repository      = data.github_repository.website-tafelboy-de.id
  secret_name     = data.bitwarden_item_login.website-tafelboy-de_FTP_PASS.username
  plaintext_value = data.bitwarden_item_login.website-tafelboy-de_FTP_PASS.password
}
