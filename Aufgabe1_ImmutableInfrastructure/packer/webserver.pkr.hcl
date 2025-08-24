// Packer template: builds a Docker image with a static web app baked in.
// Immutable principle: configuration is part of the image; no mutation at runtime.

variable "app_version" {
  type    = string
  default = "v1"
}

source "docker" "nginx" {
  image  = "nginx:alpine"
  commit = true
  changes = [
    "EXPOSE 80"
  ]
}

build {
  name    = "immutable-web"
  sources = ["source.docker.nginx"]

  provisioner "file" {
    source      = "content/${var.app_version}/index.html"
    destination = "/usr/share/nginx/html/index.html"
  }

  post-processor "docker-tag" {
    repository = "local/immutable-web"
    tags       = ["${var.app_version}"]
  }
}
