output "network_name" {
  description = "The name of the VPC"
  value       = google_compute_network.caralert247-staging-vpc.name
}

output "subnet_name" {
  description = "The name of the subnetwork"
  value       = google_compute_subnetwork.caralert247-staging-subnet1.name
}

output "subnet_self_link" {
  description = "The URI of the subnetwork (Best for GKE/GCE references)"
  value       = google_compute_subnetwork.caralert247-staging-subnet1.self_link
}

output "secondary_range_name" {
  value = google_compute_subnetwork.caralert247-staging-subnet1.secondary_ip_range[0].range_name
}
