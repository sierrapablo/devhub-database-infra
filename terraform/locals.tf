locals {
  database_network_name = coalesce(
    var.database_network_name,
    "${var.project_name}-${var.environment}-network"
  )
}
