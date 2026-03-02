# --- Network Module Pass-through ---

output "vpc_name" {
  description = "The name of the VPC created in the network module"
  value       = module.network.network_name
}

output "subnet_name" {
  description = "The name of the staging subnetwork"
  value       = module.network.subnet_name
}

output "subnet_self_link" {
  description = "The URI of the subnetwork"
  value       = module.network.subnetwork_self_link
}

output "gke_secondary_range_name" {
  description = "The secondary range name intended for GKE pods/services"
  value       = module.network.secondary_range_name
}

# --- Compute Module Pass-through ---

output "jenkins_public_ip" {
  description = "The external IP address to access the Jenkins UI"
  value       = module.compute.jenkins_public_ip
}

output "jenkins_internal_ip" {
  description = "The private IP address of the Jenkins VM"
  value       = module.compute.jenkins_internal_ip
}

# --- Functional Helpers ---

output "jenkins_access_url" {
  description = "Direct link to the Jenkins setup page"
  value       = "http://${module.compute.jenkins_public_ip}:8080"
}
