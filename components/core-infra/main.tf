terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.76.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "3.76.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "2.23.0"
    }
  }
}

locals {
  gcp_project_id = google_project.project.project_id
}

provider "google" {
  alias  = "project-only"
  region = var.gcp_region
}

provider "google" {
  project = local.gcp_project_id
  region  = var.gcp_region
}

provider "google-beta" {
  project = local.gcp_project_id
  region  = var.gcp_region
}

data "google_compute_zones" "available" {
  project = local.gcp_project_id
}
