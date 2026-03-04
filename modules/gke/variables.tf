variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
}

variable "cluster_location" {
  description = "Location of the GKE cluster."
  type        = string
}
variable "node_pool_name" {
  description = "The name of the GKE node pool."
  type        = string
}

variable "node_pool_location" {
  description = "Location of the GKE node pool."
  type        = string
}

variable "network_name" {
  description = "GKE cluster network"
  type        = string
}

variable "subnet_self_link" {
  description = "The self link of the subnetwork."
  type        = string
}
