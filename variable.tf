variable "project" {
  description = "The ID of the project where this VPC will be created"
}

variable "metric_display_name" {
  type = string
}

variable "metric_name" {
  type = string
}

variable "notification_email_address" {
  type = "string"
}

variable "activate_apis" {
  description = "The list of apis to activate within the project"
  default     = ["logging.googleapis.com", "monitoring.googleapis.com"]
  type        = list(string)
}
