variable "repo_name" {
  description = "The repo to configure with issues and templates"
  type        = string
}

variable "project" {
  description = "The URL to the Github project"
  type        = string
}

variable "issue_labels" {
  description = "Auto-assign these labels to issues (other than 'user-story')"
  type        = string
  default     = "'task'"
}
