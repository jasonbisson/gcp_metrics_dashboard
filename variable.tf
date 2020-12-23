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

variable "disable_services_on_destroy" {
  description = "Whether project services will be disabled when the resources are destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_on_destroy"
  default     = "false"
  type        = "string"
}

variable "disable_dependent_services" {
  description = "Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_dependent_services"
  default     = "false"
  type        = "string"
}