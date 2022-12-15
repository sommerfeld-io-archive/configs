resource "github_issue_label" "bug" {
  repository  = data.github_repository.trashbox.id
  name        = "bug"
  description = "Something is not working"
  color       = "B60205"
}

resource "github_issue_label" "security" {
  repository  = data.github_repository.trashbox.id
  name        = "security"
  description = "CVEs, code scan violations, etc."
  color       = "cd3ad7"
}

resource "github_issue_label" "blocked_waiting" {
  repository  = data.github_repository.trashbox.id
  name        = "blocked / waiting"
  description = "Issues that are blocked or waiting for something"
  color       = "5319E7"
}

resource "github_issue_label" "cancelled" {
  repository  = data.github_repository.trashbox.id
  name        = "cancelled"
  description = "No further actions, Issues should be closed"
  color       = "726b73"
}

resource "github_issue_label" "dependencies" {
  repository  = data.github_repository.trashbox.id
  name        = "dependencies"
  description = "Pull requests that update a dependency file (from Dependabot)"
  color       = "0366d6"
}

resource "github_issue_label" "prio_high" {
  repository  = data.github_repository.trashbox.id
  name        = "prio-high"
  description = "High priority issues"
  color       = "D93F0B"
}
