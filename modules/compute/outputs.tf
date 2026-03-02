output "jenkins_public_ip" {
  description = "The external IP address of the Jenkins instance"
  value       = google_compute_instance.jenkins_instance.network_interface[0].access_config[0].nat_ip
}

output "jenkins_internal_ip" {
  description = "The internal IP address for VPC-only access"
  value       = google_compute_instance.jenkins_instance.network_interface[0].network_ip
}
