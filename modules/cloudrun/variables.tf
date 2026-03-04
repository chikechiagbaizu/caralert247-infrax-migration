variable "caralert247_services" {
  description = "Map of Cloud Run services and their corresponding container images."
  type        = map(string)
}
variable "cloudrun_region" {
  description = "The region where the Cloud Run services will be deployed."
  type        = string
  default     = "europe-west2"
}
