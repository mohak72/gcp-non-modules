variable "project_id" {}
variable "region" {}
variable "zone" {}

variable "cluster_name" {}
variable "network" {}
variable "private_endpoint_subnetwork" {}

variable "gke_service_account" {}
variable "auto_provisioning_disk_size" {}
variable "image_type" {}

variable "master_ipv4_cidr" {}
variable "release_channel" {}

variable "persistent_disk_name" {}
variable "disk_type" {}
variable "persistent_disk_image" {}
variable "persistent_disk_size" {}

variable "pvc_name" {}
variable "pvc_storage_class" {}

variable "topic_name" {}
variable "subscription_name" {}
variable "ack_deadline_seconds" {}
variable "enable_message_ordering" {}
variable "message_retention_duration" {}

variable "static_ip_name" {}
