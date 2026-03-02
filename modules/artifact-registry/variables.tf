variable "location" {
  description = "The location of the Artifact Registry repository"
  type        = string
  default     = "europe-west2"
}

variable "description" {
  description = "Description of the Artifact Registry repository"
  type        = string
  default     = "CarAlert247 Docker Artifact Registry"
}

variable "repository_id" {
  description = "The ID of the Artifact Registry repository"
  type        = string
  default     = "caralert247-registry"
}
