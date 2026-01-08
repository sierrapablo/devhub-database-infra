variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "devhub-database"
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  default     = "prod"
}

variable "database_network_name" {
  description = "Nombre de la red de la base de datos"
  type        = string
  default     = var.project_name + "-" + var.environment + "-network"
}

variable "database_network_external" {
  description = "Indica si la red de la base de datos es externa"
  type        = bool
  default     = false
}