resource "github_issue_label" "bug" {
  repository  = var.repo_name
  name        = "bug"
  description = "Something is not working"
  color       = "B60205"
}

resource "github_issue_label" "security" {
  repository  = var.repo_name
  name        = "security"
  description = "CVEs, code scan violations, etc."
  color       = "cd3ad7"
}

resource "github_issue_label" "blocked_waiting" {
  repository  = var.repo_name
  name        = "blocked / waiting"
  description = "Issues that are blocked or waiting for something"
  color       = "5319E7"
}

resource "github_issue_label" "cancelled" {
  repository  = var.repo_name
  name        = "cancelled"
  description = "No further actions, Issues should be closed"
  color       = "726b73"
}

resource "github_issue_label" "prio_high" {
  repository  = var.repo_name
  name        = "prio-high"
  description = "High priority issues"
  color       = "D93F0B"
}

resource "github_issue_label" "dependencies" {
  repository  = var.repo_name
  name        = "dependencies"
  description = "Dependabot: Pull requests that update a dependency file"
  color       = "000000"
}

resource "github_issue_label" "github_actions" {
  repository  = var.repo_name
  name        = "github_actions"
  description = "Dependabot: Pull requests that update GitHub Actions code"
  color       = "000000"
}

resource "github_issue_label" "docker" {
  repository  = var.repo_name
  name        = "docker"
  description = "Dependabot: Pull requests that update Docker code"
  color       = "000000"
}
