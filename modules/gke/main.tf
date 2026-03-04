# Create the dedicated Service Account for GKE Nodes
resource "google_service_account" "gke_nodes" {
  account_id   = "staging-caralert247-gke-sa"
  display_name = "GKE Nodes Service Account"
}

resource "google_project_iam_member" "gke_node_roles" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/artifactregistry.reader"
  ])

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_container_cluster" "staging-caralert247" {
  name     = var.cluster_name
  location = var.cluster_location

  network    = var.network_name
  subnetwork = var.subnet_self_link

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods-range"
    services_secondary_range_name = "gke-services-range"
  }

  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false
}

resource "google_container_node_pool" "default-pool" {
  name       = var.node_pool_name
  location   = var.cluster_location
  cluster    = google_container_cluster.staging-caralert247.name
  node_count = 2

  depends_on = [google_project_iam_member.gke_node_roles]

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = "e2-medium"
    disk_size_gb = 50
    disk_type    = "pd-balanced"

    service_account = google_service_account.gke_nodes.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
