module "databse_network" {
  source = "./modules/network"

  name     = local.database_network_name
  external = var.database_network_external
}

module "postgres_volume" {
  source = "./modules/volume"

  name     = local.postgres_volume_name
  external = var.postgres_volume_external
}

module "postgres" {
  source = "./modules/postgres"

  name          = local.postgres_container_name
  image         = var.postgres_image
  network_name  = module.databse_network.name
  volume_name   = module.postgres_volume.name
  internal_port = var.postgres_internal_port
  external_port = var.postgres_external_port
  database_name = var.postgres_database
  username      = var.postgres_username
  password      = var.postgres_password
}
