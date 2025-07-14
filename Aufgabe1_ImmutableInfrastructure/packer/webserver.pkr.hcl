# -----------------------------------------------------------------------------
# PACKER TEMPLATE MIT VARIABLEN
# -----------------------------------------------------------------------------

packer {
  required_plugins {
    docker = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/docker"
    }
  }
}

# -----------------------------------------------------------------------------
# VARIABLEN
# -----------------------------------------------------------------------------

variable "app_version" {
  type    = string
  default = "v1"
  description = "Version der App, z. B. v1 oder v2"
}

variable "image_tag" {
  type    = string
  default = "v1"
  description = "Docker Image Tag, z. B. v1 oder v2"
}

# -----------------------------------------------------------------------------
# SOURCE
# -----------------------------------------------------------------------------

source "docker" "nginx" {
  image  = "nginx:latest"
  commit = true
}

# -----------------------------------------------------------------------------
# BUILD
# -----------------------------------------------------------------------------

build {
  sources = ["source.docker.nginx"]

  # Datei aus dem versionierten App-Ordner kopieren
  provisioner "file" {
    source      = "../app/${var.app_version}/index.html"
    destination = "/usr/share/nginx/html/index.html"
  }

  # Docker Image mit Versionstag versehen
  post-processor "docker-tag" {
    repository = "immutable-nginx"
    tag        = [var.image_tag]
  }
}
