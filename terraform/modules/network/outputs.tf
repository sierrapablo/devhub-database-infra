output "id" {
  description = "ID de la red Docker"
  value       = var.external ? data.docker_network.this[0].id : docker_network.this[0].id
}

output "name" {
  description = "Nombre de la red Docker"
  value       = var.name
}