resource "google_container_cluster" "gke" {
  name     = var.cluster_name
  location = var.region
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
      cidr_block   = var.master_ipv4_cidr
      display_name = "AuthorizedNetworkTest"
    }
  }

  release_channel {
    channel = var.release_channel
  }
}

# ✅ Mount Block Storage to GKE
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
    name = var.pvc_name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.pvc_storage_class

    resources {
      requests = {
        storage = "${var.persistent_disk_size}Gi"
      }
    }
  }
}
