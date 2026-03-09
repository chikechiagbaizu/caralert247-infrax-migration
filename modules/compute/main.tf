resource "google_compute_address" "caralert247-jenkins-instance-ip" {
  name   = "${var.instance_name}-ip"
  region = var.region
}

resource "google_compute_instance" "caralert247-jenkins-instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone[2]

  tags = ["jenkins-instance", "staging"]

  boot_disk {
    initialize_params {
      image = var.boot_image
      size  = var.boot_disk_size
    }
  }

  attached_disk {
    source      = google_compute_disk.jenkins_data_disk.id
    device_name = "jenkins-data"
  }

  network_interface {
    subnetwork = var.subnet_self_link
    access_config {
      nat_ip = google_compute_address.caralert247-jenkins-instance-ip.address
    }
  }
}

resource "google_compute_disk" "jenkins_data_disk" {
  name = var.disk_name
  type = var.disk_type
  zone = var.zone[2]
  size = var.disk_size
}
