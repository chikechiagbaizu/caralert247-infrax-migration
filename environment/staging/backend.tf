terraform {
  backend "gcs" {
    bucket             = "caralert247-488712-terraform-state"
    prefix             = "staging"
    kms_encryption_key = "projects/caralert247-488712/locations/europe-west2/keyRings/tf-state-keyring/cryptoKeys/tf-state-key"
  }
}
