variable "name" {
  description = "Nombre del contenedor Docker"
  type        = string
}

variable "image" {
  description = "Imagen de Postgres"
  type        = string
  default     = "postgres:16"
}

variable "keep_image_locally" {
  description = "Indica si se mantiene la imagen localmente"
  type        = bool
  default     = true
}

variable "restart_policy" {
  description = "Politica de reinicio del contenedor"
  type        = string
  default     = "unless-stopped"
}

variable "network_name" {
  description = "Nombre de la red Docker"
  type        = string
}

variable "volume_name" {
  description = "Nombre del volumen para datos"
  type        = string
}

variable "data_dir" {
  description = "Ruta de datos en el contenedor"
  type        = string
  default     = "/var/lib/postgresql/data"
}

variable "internal_port" {
  description = "Puerto interno del contenedor"
  type        = number
  default     = 5432
}

variable "external_port" {
  description = "Puerto externo expuesto"
  type        = number
  default     = 5432
}

variable "database_name" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "postgres"
}

variable "username" {
  description = "Usuario de Postgres"
  type        = string
  default     = "postgres"
}

variable "password" {
  description = "Password de Postgres"
  type        = string
  sensitive   = true
  default     = "postgres"
}
