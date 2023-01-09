variable "repo_name" {
  description = "The repo to configure with Docker pipelines"
  type        = string
}

variable "image_name" {
  description = "The name of the Docker image in the target repo (e.g. `sommerfeldio/git`)"
  type        = string
}

variable "image_tag" {
  description = "The tag of the Docker image in the target repo (e.g. `latest`)"
  type        = string
}

variable "dockerfile" {
  description = "The path to the Dockerfile in the target repo (e.g. `src/main/Dockerfile`)"
  type        = string
}
