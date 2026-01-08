variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "devhub-database"
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  default     = "dev"
}

variable "database_network_name" {
  description = "Nombre de la red de la base de datos"
  type        = string
  default     = null
}

variable "database_network_external" {
  description = "Indica si la red de la base de datos es externa"
  type        = bool
  default     = false
}

variable "postgres_volume_name" {
  description = "Nombre del volumen de Postgres"
  type        = string
  default     = null
}

variable "postgres_volume_external" {
  description = "Indica si el volumen de Postgres es externo"
  type        = bool
  default     = false
}

variable "postgres_container_name" {
  description = "Nombre del contenedor de Postgres"
  type        = string
  default     = null
}

variable "postgres_image" {
  description = "Imagen de Postgres"
  type        = string
  default     = "postgres:16"
}

variable "postgres_internal_port" {
  description = "Puerto interno de Postgres"
  type        = number
  default     = 5432
}

variable "postgres_external_port" {
  description = "Puerto externo de Postgres"
  type        = number
  default     = 5432
}

variable "postgres_database" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "postgres"
}

variable "postgres_username" {
  description = "Usuario de Postgres"
  type        = string
  default     = "postgres"
}

variable "postgres_password" {
  description = "Password de Postgres"
  type        = string
  sensitive   = true
  default     = "postgres"
}
