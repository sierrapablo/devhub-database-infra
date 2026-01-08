module "databse_network" {
  source = "./modules/network"

  name     = var.database_network_name
  external = var.database_network_external
}