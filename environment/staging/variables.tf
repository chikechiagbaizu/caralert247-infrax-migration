# Artifact Registry
variable "location" {
  description = "The location of the Artifact Registry repository"
  type        = string
}

variable "description" {
  description = "Description of the Artifact Registry repository"
  type        = string
}

variable "repository_id" {
  description = "The ID of the Artifact Registry repository"
  type        = string
}

# Jenkins Compute Instance
variable "instance_name" {
  description = "The name of the compute instance."
  type        = string
}

variable "machine_type" {
  description = "The machine type for the compute instance."
  type        = string
}

variable "zone" {
  description = "Availability zones for launching instances"
  type        = list(string)
}

variable "boot_image" {
  description = "The boot image for the compute instance."
  type        = string
}

variable "boot_disk_size" {
  description = "The size of the boot disk in GB."
  type        = number
}

# Jenkins Data Disk
variable "disk_name" {
  description = "The name of the additional disk."
  type        = string
}

variable "disk_type" {
  description = "The type of the additional disk."
  type        = string
}

variable "disk_size" {
  description = "The size of the additional disk in GB."
  type        = number
}

# Network
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
}

variable "secondary_ip_cidr_range" {
  description = "Secondary IP CIDR range of the subnet"
  type        = string
}

variable "region" {
  description = "The region where the subnet will be created."
  type        = string
}

# GKE Cluster
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
