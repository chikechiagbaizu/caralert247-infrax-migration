resource "google_cloud_run_v2_service" "caralert247-services" {
  for_each = var.caralert247_services

  name                = each.key
  location            = var.cloudrun_region
  ingress             = "INGRESS_TRAFFIC_ALL"
  deletion_protection = false

  template {
    scaling {
      max_instance_count = 5
    }

    containers {
      image = each.value
    }
  }
}

resource "google_cloud_run_v2_service_iam_member" "public_access" {
  for_each = google_cloud_run_v2_service.caralert247-services

  location = each.value.location
  name     = each.value.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
