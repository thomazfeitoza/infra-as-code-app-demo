variable "gcp_billing_account" {
  type        = string
  description = "Google Cloud billing account identifier."
}

variable "gcp_organization_id" {
  type        = string
  description = "Organization identifer in Google Cloud."
  default     = null
}

variable "gcp_region" {
  type        = string
  description = "Google Cloud region used to deploy the resources."
  default     = "us-east-1"
}

variable "app_domain" {
  type        = string
  description = "Domain name for web applications."
}
