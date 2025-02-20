# GKE Cluster Configuration
resource "google_container_cluster" "gkefit_r_central1" {
  name     = "gkefit-r-usc1"
  location = "us-central1"
  project  = var.project_id

  network    = var.network
  subnetwork = var.private_endpoint_subnetwork

  node_config {
    service_account = var.gke_service_account
    disk_size_gb    = var.auto_provisioning_disk_size
    image_type      = var.image_type
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.8.0.0/8"
      display_name = "AuthorizedNetworkTest"
    }
  }

  release_channel {
    channel = "STABLE"
  }
}

# ✅ Mount Block Storage to GKE Cluster (Like in Screenshot)
resource "kubernetes_persistent_volume" "gke_pv" {
  metadata {
    name = google_compute_disk.gke_persistent_disk.name
  }

  spec {
    capacity = {
      storage = "${var.persistent_disk_size}Gi"
    }

    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"

    gce_persistent_disk {
      pd_name = google_compute_disk.gke_persistent_disk.name
      fs_type = "ext4"
    }
  }
}

resource "kubernetes_persistent_volume_claim" "gke_pvc" {
  metadata {
    name = "gke-pvc"
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "standard"

    resources {
      requests = {
        storage = "${var.persistent_disk_size}Gi"
      }
    }
  }
}
