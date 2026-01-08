variable "name" {
  description = "Nombre del volumen Docker"
  type        = string
}

variable "driver" {
  description = "Driver del volumen Docker"
  type        = string
  default     = "local"
}

variable "external" {
  description = "Indica si el volumen es externo (no gestionado por Terraform)"
  type        = bool
  default     = false
}
