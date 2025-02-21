resource "google_pubsub_topic" "pubsub_topic" {
  name                        = var.topic_name
  project                     = var.project_id
  message_retention_duration  = var.message_retention_duration
  labels                      = {
    environment = "dev"
  }
  message_storage_policy {
    allowed_persistence_regions = [var.region]
  }
}

resource "google_pubsub_subscription" "pubsub_subscription" {
  name  = var.subscription_name
  topic = google_pubsub_topic.pubsub_topic.id

  ack_deadline_seconds = var.ack_deadline_seconds
  enable_message_ordering = var.enable_message_ordering

  # Push subscription (optional)
  dynamic "push_config" {
    for_each = var.push_endpoint != "" ? [1] : []
    content {
      push_endpoint = var.push_endpoint
    }
  }

  # Retain messages if not acknowledged
  retain_acked_messages = true
  message_retention_duration = var.message_retention_duration
}
