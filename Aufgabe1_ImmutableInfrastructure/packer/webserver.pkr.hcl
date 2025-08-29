// Packer template: builds one Docker image with all Python code baked in.
// Multiple containers (one process each) will use different commands at runtime.

variable "app_version" {
  type    = string
  default = "v1"
}

source "docker" "python" {
  image  = "python:3.11-slim"
  commit = true
  changes = [
    // Streamlit-UI lauscht später im Web-Container auf 8501
    "EXPOSE 8501"
    // KEIN ENTRYPOINT hier – wir überschreiben den Befehl pro Container in Terraform
  ]
}

build {
  name    = "immutable-web"
  sources = ["source.docker.python"]

  // Versionierten App-Code in /app/ backen (v1 oder v2)
  provisioner "file" {
    source      = "content/${var.app_version}/"
    destination = "/app/"
  }

  // Dependencies installieren
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
