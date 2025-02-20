resource "google_pubsub_topic" "pubsub_topic" {
  name    = var.topic_name
  project = var.project_id
}

resource "google_pubsub_subscription" "pubsub_subscription" {
  name  = var.subscription_name
  topic = google_pubsub_topic.pubsub_topic.id

  ack_deadline_seconds       = var.ack_deadline_seconds
  enable_message_ordering    = var.enable_message_ordering
  message_retention_duration = var.message_retention_duration
}
