module "network" {
  source                  = "../../modules/network"
  network_name            = var.network_name
  subnet_name             = var.subnet_name
  primary_ip_cidr_range   = var.primary_ip_cidr_range
  secondary_ip_cidr_range = var.secondary_ip_cidr_range
  region                  = var.region

}
module "compute" {
  source         = "../../modules/compute"
  instance_name  = var.instance_name
  machine_type   = var.machine_type
  zone           = var.zone
  boot_image     = var.boot_image
  boot_disk_size = var.boot_disk_size
}
module "artifact_registry" {
  source        = "../../modules/artifact_registry"
  location      = var.location
  description   = var.description
  repository_id = var.repository_id
}
