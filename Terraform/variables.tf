variable "image_name" {
  description = "Name + Tag deines lokalen Docker-Images"
  type        = string
  default     = "immutable-nginx:v1"
}

variable "host_port" {
  description = "Port auf dem Host"
  type        = number
  default     = 8080
}
variable "docker_socket" {
  description = "Pfad zur Docker-Socket-Datei"
  type        = string
  default     = "/var/run/docker.sock"
}
