
output "database_network_name" {
  description = "Nombre de la red de la base de datos"
  value       = module.databse_network.name
}

output "postgres_volume_name" {
  description = "Nombre del volumen de Postgres"
  value       = module.postgres_volume.name
}

output "postgres_container_name" {
  description = "Nombre del contenedor de Postgres"
  value       = module.postgres.name
}
