resource "docker_network" "this" {
  count  = var.external ? 0 : 1
  name   = var.name
  driver = var.driver
}

data "docker_network" "this" {
  count = var.external ? 1 : 0
  name  = var.name
}