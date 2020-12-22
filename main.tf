
terraform {
  required_version = ">= 0.12"
  backend "gcs" {}
}

provider "google" {
  version = "~> 3.0.0"
  project = "${var.project}"
}

resource "google_project_service" "project_services" {
  count                      = var.enable_apis ? length(var.activate_apis) : 0
  service                    = element(var.activate_apis, count.index)
  disable_on_destroy         = var.disable_services_on_destroy
  disable_dependent_services = var.disable_dependent_services
}


resource "google_logging_metric" "logging_metric" {
  name   = "${var.metric_name}"
  filter = "protoPayload.authorizationInfo.permission=compute.subnetworks.useExternalIp"
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    display_name = "${var.metric_display_name}"
  }
}

resource "google_monitoring_notification_channel" "email" {
  enabled      = true
  display_name = "Send email to ${var.notification_email_address}"
  type         = "email"

  labels = {
    email_address = "${var.notification_email_address}"
  }
}


resource "google_monitoring_alert_policy" "alert_policy0" {
  display_name = "1 - Availability - Google Cloud HTTP/S Load Balancing Rule - Request count (filtered) [COUNT]"
  combiner     = "OR"
  conditions {
    display_name = "Google Cloud HTTP/S Load Balancing Rule - Request count (filtered) [COUNT]"
    condition_threshold {
      filter          = "metric.type=\"loadbalancing.googleapis.com/https/request_count\" resource.type=\"https_lb_rule\" metric.label.response_code!=\"200\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 1
      trigger {
        count = 1
      }
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_COUNT"
      }
    }
  }
  documentation {
    content = "The load balancer rule $${condition.display_name} has generated this alert for the $${metric.display_name}."
  }
  notification_channels = [
    "${google_monitoring_notification_channel.email.name}",
  ]
}
