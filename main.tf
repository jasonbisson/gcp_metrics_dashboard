
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

#resource "google_logging_metric" "log_alert_metric" {
#  for_each = {for item in local.logAlerts: item.name => item}
#  name   = each.value.name
#  filter = each.value.rule
#  metric_descriptor {
#    metric_kind = "DELTA"
#    value_type  = "INT64"
#  }
#}

resource "google_logging_metric" "metric" {
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

resource "google_monitoring_alert_policy" "alert-policy-email" {
  display_name = "${var.metric_name}"
  combiner     = "OR"
  project      = var.project

  conditions {
    display_name = "${var.metric_name}"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.metric.name}\" resource.type=\"global\""
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 1

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
      }
    }
  }

  notification_channels = ["${google_monitoring_notification_channel.email.name}"]
    enabled = "true"
}