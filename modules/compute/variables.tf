variable "instance_name" {
  description = "The name of the compute instance."
  type        = string
  default     = "caralert247-jenkins-instance"
}

variable "machine_type" {
  description = "The machine type for the compute instance."
  type        = string
  default     = "e2-standard-2"
}

variable "zone" {
  description = "Availability zones for launching instances"
  type        = list(string)
  default     = ["europe-west2-a", "europe-west2-b", "europe-west2-c"]
}

variable "boot_image" {
  description = "The boot image for the compute instance."
  type        = string
  default     = "debian-cloud/debian-12"
}

variable "boot_disk_size" {
  description = "The size of the boot disk in GB."
  type        = number
  default     = 30
}

variable "disk_name" {
  description = "The name of the additional disk."
  type        = string
  default     = "jenkins-data-disk"
}

variable "disk_type" {
  description = "The type of the additional disk."
  type        = string
  default     = "pd-balanced"
}

variable "disk_size" {
  description = "The size of the additional disk in GB."
  type        = number
  default     = 50
}

variable "network_name" {
  description = "The name of the network."
  type        = string
}

variable "subnet_self_link" {
  description = "The self link of the subnetwork."
  type        = string
}

variable "region" {
  description = "Instance location"
  type        = string
}
