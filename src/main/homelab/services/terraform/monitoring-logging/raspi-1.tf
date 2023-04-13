terraform {
  required_version = "1.4.5"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host     = "ssh://vagrant@127.0.0.1:2222"
  ssh_opts = ["-F", ".vagrant-ssh.config"]
}

resource "docker_image" "website" {
  name = "sommerfeldio/website:latest"
}

resource "docker_container" "website" {
  image = docker_image.website.image_id
  name  = "website"

  ports {
    internal = "8000"
    external = "8000"
  }
}
