locals {
  database_network_name = coalesce(
    var.database_network_name,
    "${var.project_name}-${var.environment}-network"
  )

  postgres_volume_name = coalesce(
    var.postgres_volume_name,
    "${var.project_name}-${var.environment}-postgres-data"
  )

  postgres_container_name = coalesce(
    var.postgres_container_name,
    "${var.project_name}-${var.environment}-postgres"
  )
}
