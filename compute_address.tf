resource "google_compute_address" "istio_static_ip" {
  name   = var.static_ip_name
  region = var.region
}
