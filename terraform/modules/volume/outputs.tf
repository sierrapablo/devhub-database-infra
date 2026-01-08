output "id" {
  description = "ID del volumen Docker"
  value       = docker_volume.this.id
}

output "name" {
  description = "Nombre del volumen Docker"
  value       = docker_volume.this.name
}
