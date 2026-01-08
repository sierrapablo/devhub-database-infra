output "id" {
  description = "ID del contenedor de Postgres"
  value       = docker_container.this.id
}

output "name" {
  description = "Nombre del contenedor de Postgres"
  value       = docker_container.this.name
}

output "image" {
  description = "Imagen usada por el contenedor"
  value       = docker_container.this.image
}
