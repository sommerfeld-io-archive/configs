resource "github_repository_file" "workflow_assign_issues" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] Update Github Actions workflow"
  overwrite_on_create = true
  file                = ".github/workflows/organize-assign-issues.yml"
  content = templatefile("${path.module}/assets/workflows/organize-assign-issues-tftpl.yml", {
    project = "${var.project}"
  })
}

resource "github_repository_file" "workflow_auto_close_issues" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] Update Github Actions workflow"
  overwrite_on_create = true
  file                = ".github/workflows/organize-auto-close-issues.yml"
  content             = file("${path.module}/assets/workflows/organize-auto-close-issues.yml")
}

resource "github_repository_file" "workflow_dependabot" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] Update Github Actions workflow"
  overwrite_on_create = true
  file                = ".github/workflows/organize-dependabot.yml"
  content             = file("${path.module}/assets/workflows/organize-dependabot.yml")
}
