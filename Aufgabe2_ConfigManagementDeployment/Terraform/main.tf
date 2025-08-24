provider "docker" {}

variable "image_tag" {
  description = "Image tag (v1, v2, ...) to deploy"
  type        = string
  default     = "v1"
}

variable "host_port" {
  description = "Host port to expose the web app"
  type        = number
  default     = 8080
}

variable "container_name" {
  description = "Name of the running container"
  type        = string
  default     = "immutable-web"
}

resource "docker_container" "app" {
  name  = var.container_name
  image = "local/immutable-web:${var.image_tag}"

  ports {
    internal = 80
    external = var.host_port
  }

  // No volumes: no mutation of app content at runtime
  restart = "always"
}

output "url" {
  value = "http://localhost:${var.host_port}"
}
