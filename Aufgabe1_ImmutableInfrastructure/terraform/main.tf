provider "docker" {}

variable "image_tag" {
  description = "Image tag (v1, v2, ...) to deploy"
  type        = string
  default     = "v1"
}

variable "host_port" {
  description = "Host port for the Streamlit frontend"
  type        = number
  default     = 8080
}

variable "name_prefix" {
  description = "Prefix for container names"
  type        = string
  default     = "immutable"
}

# Gemeinsames Docker-Netz
resource "docker_network" "app" {
  name = "${var.name_prefix}_net"
}

locals {
  image = "local/immutable-web:${var.image_tag}"
}

############################
# Web-Frontend (Streamlit) #
############################
resource "docker_container" "web" {
  name  = "${var.name_prefix}-web"
  image = local.image

  # Port-Mapping: 8501 (intern) -> host_port (extern)
  ports {
    internal = 8501
    external = var.host_port
  }

  # Pro-Container Command (statt ENTRYPOINT im Image)
  command = [
    "streamlit", "run", "/app/streamlit_app.py",
    "--server.port", "8501",
    "--server.address", "0.0.0.0"
  ]

  networks_advanced {
    name = docker_network.app.name
  }

  restart = "always"
}

####################
# Worker-Container #
####################

resource "docker_container" "tick_collector" {
  name    = "${var.name_prefix}-tick"
  image   = local.image
  command = ["python", "/app/tick_collector.py"]

  networks_advanced { name = docker_network.app.name }
  restart = "always"
}

resource "docker_container" "ohlcv_aggregator" {
  name    = "${var.name_prefix}-agg"
  image   = local.image
  command = ["python", "/app/ohlcv_aggregator.py"]

  networks_advanced { name = docker_network.app.name }
  restart = "always"
}

resource "docker_container" "volatility_detector" {
  name    = "${var.name_prefix}-vol"
  image   = local.image
  command = ["python", "/app/volatility_detector.py"]

  networks_advanced { name = docker_network.app.name }
  restart = "always"
}

output "url" {
  description = "URL of the Streamlit web interface"
  value       = "http://localhost:${var.host_port}"
}
