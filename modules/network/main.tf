resource "google_compute_network" "caralert247-staging-vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "caralert247-staging-subnet1" {
  name          = var.subnet_name
  ip_cidr_range = var.primary_ip_cidr_range
  region        = var.region
  network       = google_compute_network.caralert247-staging-vpc.id

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "gke-pods-range"
    ip_cidr_range = "192.168.0.0/18"
  }

  secondary_ip_range {
    range_name    = "gke-services-range"
    ip_cidr_range = "192.168.64.0/24"
  }

}
