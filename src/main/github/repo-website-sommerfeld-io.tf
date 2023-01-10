# Repository
# https://github.com/sebastian-sommerfeld-io/website-sommerfeld-io

data "github_repository" "website-sommerfeld-io" {
  full_name = "sebastian-sommerfeld-io/website-sommerfeld-io"
}

module "website-sommerfeld-io-issues" {
  source    = "./modules/issues"
  repo_name = data.github_repository.website-sommerfeld-io.id
  project   = "https://github.com/users/sebastian-sommerfeld-io/projects/1"
}

module "website-sommerfeld-io-docker-pipelines" {
  source     = "./modules/docker-pipelines"
  repo_name  = data.github_repository.website-sommerfeld-io.id
  image_name = "sommerfeldio/website"
  image_tag  = "latest"
  dockerfile = "src/main/Dockerfile"
}

resource "github_actions_secret" "website-sommerfeld-io_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.website-sommerfeld-io.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "website-sommerfeld-io_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.website-sommerfeld-io.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}

resource "github_actions_secret" "website-sommerfeld-io_SNYK_TOKEN" {
  repository      = data.github_repository.website-sommerfeld-io.id
  secret_name     = data.bitwarden_item_login.SNYK_TOKEN.username
  plaintext_value = data.bitwarden_item_login.SNYK_TOKEN.password
}

resource "github_actions_secret" "website-sommerfeld-io_DOCKERHUB_USER" {
  repository      = data.github_repository.website-sommerfeld-io.id
  secret_name     = data.bitwarden_item_login.DOCKERHUB_USER.username
  plaintext_value = data.bitwarden_item_login.DOCKERHUB_USER.password
}

data "bitwarden_item_login" "website-sommerfeld-io_DOCKERHUB_TOKEN" {
  id = "27de4359-0c2f-4757-bb82-af7100d54641"
}
resource "github_actions_secret" "website-sommerfeld-io_DOCKERHUB_TOKEN" {
  repository      = data.github_repository.website-sommerfeld-io.id
  secret_name     = data.bitwarden_item_login.website-sommerfeld-io_DOCKERHUB_TOKEN.username
  plaintext_value = data.bitwarden_item_login.website-sommerfeld-io_DOCKERHUB_TOKEN.password
}

data "bitwarden_item_login" "website-sommerfeld-io_FTP_USER" {
  id = "79ace941-4efc-4985-8d94-af7100d6c3ed"
}
resource "github_actions_secret" "website-sommerfeld-io_FTP_USER" {
  repository      = data.github_repository.website-sommerfeld-io.id
  secret_name     = data.bitwarden_item_login.website-sommerfeld-io_FTP_USER.username
  plaintext_value = data.bitwarden_item_login.website-sommerfeld-io_FTP_USER.password
}

data "bitwarden_item_login" "website-sommerfeld-io_FTP_PASS" {
  id = "a542a30b-3ede-4587-a5bf-af7100d6b291"
}
resource "github_actions_secret" "website-sommerfeld-io_FTP_PASS" {
  repository      = data.github_repository.website-sommerfeld-io.id
  secret_name     = data.bitwarden_item_login.website-sommerfeld-io_FTP_PASS.username
  plaintext_value = data.bitwarden_item_login.website-sommerfeld-io_FTP_PASS.password
}
