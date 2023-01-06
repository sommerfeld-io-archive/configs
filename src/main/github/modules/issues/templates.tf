resource "github_repository_file" "template_user_story" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] Template update"
  overwrite_on_create = true
  file                = ".github/ISSUE_TEMPLATE/user-story.md"
  content             = <<-EOT
    ---
    name: User Story
    about: Describe a new features (only one single feature at best)
    title: ''
    labels: ${resource.github_issue_label.story.name}
    assignees: ''
    ---

    As a _role_ I can _capability_, so that _receive benefit_.

    ### Acceptance Criteria
    - [ ] Describe what criteria the user story must meet.
    - [ ] Be precise! 
    - [ ] You should be able to create a dedicated implementation task (and a test case at best) for each criteria.
  EOT
}

resource "github_repository_file" "template_pull_request" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] Template update"
  overwrite_on_create = true
  file                = ".github/PULL_REQUEST_TEMPLATE.md"
  content             = <<-EOT
    # Description
    Please include a summary of the change and which issue is fixed. Please also include relevant motivation and context. List any dependencies that are required for this change.

    Link Github Issues if possible.

    ## Type of change
    Please delete options that are not relevant.
    - [ ] Bug fix (non-breaking change which fixes an issue)
    - [ ] New feature (non-breaking change which adds functionality)
    - [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
  EOT
}
