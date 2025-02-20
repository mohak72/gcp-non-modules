resource "google_compute_disk" "gke_persistent_disk" {
  name  = var.persistent_disk_name
  type  = "pd-ssd"
  zone  = "us-central1-c"
  image = var.persistent_disk_image

  labels = {
    environment = local.labels.aexp-app-env
  }

  physical_block_size_bytes = var.persistent_disk_size
}
