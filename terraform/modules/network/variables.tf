variable "name" {
  description = "Nombre de la red Docker"
  type        = string
}

variable "driver" {
  description = "Driver de la red Docker"
  type        = string
  default     = "bridge"
}

variable "external" {
  description = "Indica si la red es externa (no gestionada por Terraform)"
  type        = bool
  default     = false
}
