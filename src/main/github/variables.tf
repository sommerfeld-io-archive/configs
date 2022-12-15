variable "gh_token" {
  description = "Github Personal Access Token"
  type        = string
  sensitive   = true
}

variable "github_user" {
  description = "Github User containing the repositories"
  type        = string
  default     = "sebastian-sommerfeld-io"
}
