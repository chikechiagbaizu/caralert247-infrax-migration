output "jenkins_public_ip" {
  description = "The external IP address of the Jenkins instance"
  value       = google_compute_address.caralert247-jenkins_static_ip.address
}

output "jenkins_internal_ip" {
  description = "The internal IP address for VPC-only access"
  value       = google_compute_instance.caralert247-jenkins-instance.network_interface[0].network_ip
}
