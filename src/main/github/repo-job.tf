# Repository
# https://github.com/sebastian-sommerfeld-io/job

data "github_repository" "job" {
  full_name = "sebastian-sommerfeld-io/job"
}

module "job-issues" {
  source    = "./modules/issues"
  repo_name = data.github_repository.job.id
  project   = "https://github.com/users/sebastian-sommerfeld-io/projects/4"
}

resource "github_actions_secret" "job_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.job.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "job_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.job.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}
