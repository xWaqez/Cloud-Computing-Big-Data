terraform {
  required_version = ">= 1.4.0"

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

############################
# VARIABLES
############################

variable "image_name" {
  description = "Name und Tag deines lokalen Docker-Images"
  type        = string
  default     = "immutable-nginx:v1"
}

variable "host_port" {
  description = "Port auf dem Host"
  type        = number
  default     = 8080
}

############################
# RESOURCES
############################

resource "docker_image" "immutable_nginx" {
  name         = var.image_name
  keep_locally = true
}

resource "docker_container" "webserver" {
  name  = "immutable_webserver"
  image = docker_image.immutable_nginx.name

  ports {
    internal = 80
    external = var.host_port
  }
}

############################
# OUTPUTS
############################

output "container_name" {
  value = docker_container.webserver.name
}

output "webserver_url" {
  value = "http://localhost:${var.host_port}"
}
output "image_name" {
  value = docker_image.immutable_nginx.name
}
