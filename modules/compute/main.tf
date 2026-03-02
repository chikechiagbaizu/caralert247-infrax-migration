resource "google_compute_instance" "caralert247-jenkins-instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone[2]

  tags = ["jenkins_instance", "staging"]

  boot_disk {
    initialize_params {
      image = var.boot_image
      size  = var.boot_disk_size
    }
  }

  network_interface {
    subnetwork = module.network.subnet_self_link

    access_config {
    }
  }

  #   metadata_startup_script = ""
}

resource "google_compute_disk" "jenkins_data_disk" {
  name = var.disk_name
  type = var.disk_type
  zone = var.zone[2]
  size = var.disk_size
  labels = {
    environment = "staging"
    project     = "caralert247"
    app         = "jenkins"
  }
  physical_block_size_bytes = 4096
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_attached_disk" "jenkins_disk_attachment" {
  disk     = google_compute_disk.jenkins_data_disk.id
  instance = google_compute_instance.jenkins_instance.id
  zone     = var.zone[2]
}

resource "google_compute_firewall" "allow_jenkins" {
  name    = "allow-jenkins-8080"
  network = module.network.network_name

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  target_tags   = ["jenkins-instance"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_SSH" {
  name    = "allow-SSH"
  network = module.network.network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags   = ["jenkins-instance"]
  source_ranges = ["0.0.0.0/0"]
}
