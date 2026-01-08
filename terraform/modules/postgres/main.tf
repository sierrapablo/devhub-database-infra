resource "docker_image" "this" {
  name         = var.image
  keep_locally = var.keep_image_locally
}

resource "docker_container" "this" {
  name  = var.name
  image = docker_image.this.name

  restart = var.restart_policy

  env = [
    "POSTGRES_DB=${var.database_name}",
    "POSTGRES_USER=${var.username}",
    "POSTGRES_PASSWORD=${var.password}",
  ]

  ports {
    internal = var.internal_port
    external = var.external_port
  }

  networks_advanced {
    name = var.network_name
  }

  volumes {
    volume_name    = var.volume_name
    container_path = var.data_dir
  }
}
