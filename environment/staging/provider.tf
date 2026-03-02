terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.21.0"
    }
  }
  required_version = "v1.14.6"
}

provider "google" {
  region  = "europe-west2"
  project = "caralert247-488712"
}
