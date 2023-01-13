resource "github_repository_file" "template_user_story" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] Template update"
  overwrite_on_create = true
  file                = ".github/ISSUE_TEMPLATE/user-story.md"
  content             = file("${path.module}/assets/templates/user-story.md")
}

resource "github_repository_file" "template_pull_request" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] Template update"
  overwrite_on_create = true
  file                = ".github/PULL_REQUEST_TEMPLATE.md"
  content             = file("${path.module}/assets/templates/PULL_REQUEST_TEMPLATE.md")
}
