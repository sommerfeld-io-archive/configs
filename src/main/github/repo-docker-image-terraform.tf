# Repository
# https://github.com/sebastian-sommerfeld-io/docker-image-terraform

data "github_repository" "docker-image-terraform" {
  full_name = "sebastian-sommerfeld-io/docker-image-terraform"
}

module "docker-image-terraform-labels" {
  source    = "./modules/issue-labels"
  repo_name = data.github_repository.docker-image-terraform.id
}

resource "github_actions_secret" "docker-image-terraform_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.docker-image-terraform.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "docker-image-terraform_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.docker-image-terraform.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}

resource "github_actions_secret" "docker-image-terraform_SNYK_TOKEN" {
  repository      = data.github_repository.docker-image-terraform.id
  secret_name     = data.bitwarden_item_login.SNYK_TOKEN.username
  plaintext_value = data.bitwarden_item_login.SNYK_TOKEN.password
}

resource "github_actions_secret" "docker-image-terraform_DOCKERHUB_USER" {
  repository      = data.github_repository.docker-image-terraform.id
  secret_name     = data.bitwarden_item_login.DOCKERHUB_USER.username
  plaintext_value = data.bitwarden_item_login.DOCKERHUB_USER.password
}

data "bitwarden_item_login" "docker-image-terraform_DOCKERHUB_TOKEN" {
  id = "15eced23-ec9d-40a7-8358-af71011de25a"
}
resource "github_actions_secret" "docker-image-terraform_DOCKERHUB_TOKEN" {
  repository      = data.github_repository.docker-image-terraform.id
  secret_name     = data.bitwarden_item_login.docker-image-terraform_DOCKERHUB_TOKEN.username
  plaintext_value = data.bitwarden_item_login.docker-image-terraform_DOCKERHUB_TOKEN.password
}
