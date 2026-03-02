variable "network_name" {
  description = "The name of the network to create."
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet to create."
  type        = string
}

variable "primary_ip_cidr_range" {
  description = "Primary IP CIDR range of the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "secondary_ip_cidr_range" {
  description = "Secondary IP CIDR range of the subnet"
  type        = string
  default     = "192.168.0.0/18"
}

variable "region" {
  description = "The region where the subnet will be created."
  type        = string
  default     = "europe-west2"
}
