terraform {
  required_version = "1.3.6"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.12.0"
    }
  }
}

provider "github" {}

module "repo-config" {
  source = "./modules/repos/sebastian-sommerfeld-io/configs"
}

module "repo-docker-image-adoc-antora" {
  source = "./modules/repos/sebastian-sommerfeld-io/docker-image-adoc-antora"
}

module "repo-docker-image-folderslint" {
  source = "./modules/repos/sebastian-sommerfeld-io/docker-image-folderslint"
}

module "repo-docker-image-ftp-client" {
  source = "./modules/repos/sebastian-sommerfeld-io/docker-image-ftp-client"
}

module "repo-docker-image-git" {
  source = "./modules/repos/sebastian-sommerfeld-io/docker-image-git"
}

module "repo-docker-image-jq" {
  source = "./modules/repos/sebastian-sommerfeld-io/docker-image-jq"
}

module "repo-docker-image-tf-graph-beautifier" {
  source = "./modules/repos/sebastian-sommerfeld-io/docker-image-tf-graph-beautifier"
}

module "repo-github-action-generate-docs" {
  source = "./modules/repos/sebastian-sommerfeld-io/github-action-generate-docs"
}

module "repo-github-action-generate-readme" {
  source = "./modules/repos/sebastian-sommerfeld-io/github-action-generate-readme"
}

module "repo-github-action-update-antora-yml" {
  source = "./modules/repos/sebastian-sommerfeld-io/github-action-update-antora-yml"
}

module "repo-jarvis" {
  source = "./modules/repos/sebastian-sommerfeld-io/jarvis"
}

module "repo-monitoring" {
  source = "./modules/repos/sebastian-sommerfeld-io/monitoring"
}

module "repo-website-masterblender-de" {
  source = "./modules/repos/sebastian-sommerfeld-io/website-masterblender-de"
}

module "repo-website-numero-uno-de" {
  source = "./modules/repos/sebastian-sommerfeld-io/website-numero-uno-de"
}

module "repo-website-sommerfeld-io" {
  source = "./modules/repos/sebastian-sommerfeld-io/website-sommerfeld-io"
}

module "repo-website-tafelboy-de" {
  source = "./modules/repos/sebastian-sommerfeld-io/website-tafelboy-de"
}

module "repo-trashbox" {
  source = "./modules/repos/sebastian-sommerfeld-io/trashbox"
}
