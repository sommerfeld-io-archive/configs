terraform {
  required_version = "1.5.1"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }

    github = {
      source  = "integrations/github"
      version = "5.42.0"
    }

    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = "0.7.2"
    }
  }
}

provider "local" {}

provider "github" {}

provider "bitwarden" {
  master_password = var.bw_password
  client_id       = var.bw_client_id
  client_secret   = var.bw_client_secret
  email           = var.bw_email
  server          = "https://vault.bitwarden.com"
}

# Github Actions Secret - Global - Relevant for all repos
data "bitwarden_item_login" "GOOGLE_CHAT_WEBHOOK" {
  id = "e2e02ec2-580b-4823-94bb-af70014ca324"
}

# Github Actions Secret - Global - Relevant for all repos
data "bitwarden_item_login" "GH_TOKEN_REPO_AND_PROJECT" {
  id = "73912f41-e080-48fb-b225-b00d00cc3db4"
}
