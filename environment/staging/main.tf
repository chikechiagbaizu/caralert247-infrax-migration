module "network" {
  source                  = "../../modules/network"
  network_name            = var.network_name
  subnet_name             = var.subnet_name
  primary_ip_cidr_range   = var.primary_ip_cidr_range
  secondary_ip_cidr_range = var.secondary_ip_cidr_range
  region                  = var.region

}
module "compute" {
  source           = "../../modules/compute"
  instance_name    = var.instance_name
  machine_type     = var.machine_type
  zone             = var.zone
  boot_image       = var.boot_image
  boot_disk_size   = var.boot_disk_size
  network_name     = module.network.network_name
  subnet_self_link = module.network.subnet_self_link
  disk_name        = var.disk_name
  disk_type        = var.disk_type
  disk_size        = var.disk_size
  region           = var.region
}
module "artifact_registry" {
  source        = "../../modules/artifact-registry"
  location      = var.location
  description   = var.description
  repository_id = var.repository_id
}

module "gke" {
  source             = "../../modules/gke"
  project_id         = var.project_id
  cluster_name       = var.cluster_name
  cluster_location   = var.cluster_location
  node_pool_name     = var.node_pool_name
  node_pool_location = var.node_pool_location
  network_name       = module.network.network_name
  subnet_self_link   = module.network.subnet_self_link
}
