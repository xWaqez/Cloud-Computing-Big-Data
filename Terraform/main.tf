terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "immutable_nginx" {
  name         = var.image_name
  keep_locally = true
}

resource "docker_container" "webserver" {
  name  = "immutable_webserver"
  image = docker_image.immutable_nginx.latest

  ports {
    internal = 80
    external = var.host_port
  }
}

output "container_id" {
  value = docker_container.webserver.id
}

output "webserver_url" {
  value = "http://localhost:${var.host_port}"
}
