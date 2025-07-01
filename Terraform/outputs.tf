output "container_name" {
  value = docker_container.webserver.name
}
output "image_name" {
  value = docker_image.immutable_nginx.name
}
output "container_id" {
  value = docker_container.webserver.id
}
output "webserver_url" {
  value = "http://localhost:${var.host_port}"
}
output "docker_socket" {
  value = var.docker_socket
}
output "host_port" {
  value = var.host_port
}
