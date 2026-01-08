output "id" {
  description = "ID del volumen Docker"
  value       = var.external ? data.docker_volume.this[0].id : docker_volume.this[0].id
}

output "name" {
  description = "Nombre del volumen Docker"
  value       = var.name
}
