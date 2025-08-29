// Packer: baut EIN Python-Image; Code + Deps sind Teil des Images.
// In Terraform starten wir mehrere Container mit unterschiedlichen Commands.

variable "app_version" {
  type    = string
  default = "v1"
}

source "docker" "python" {
  image  = "python:3.11-slim"
  commit = true
  changes = [
    // Streamlit-Frontend nutzt 8501
    "EXPOSE 8501"
  ]
}

build {
  name    = "immutable-web"
  sources = ["source.docker.python"]

  // Hier liegt dein Code: packer/v1 bzw. packer/v2
  provisioner "file" {
    source      = "${var.app_version}/"
    destination = "/app/"
  }

  provisioner "shell" {
    inline = [
      "python -m pip install --upgrade pip",
      "pip install --no-cache-dir -r /app/requirements.txt"
    ]
  }

  post-processor "docker-tag" {
    repository = "local/immutable-web"
    tags       = ["${var.app_version}"]
  }
}
