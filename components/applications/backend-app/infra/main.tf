terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.65.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.1.0"
    }
    kubernetes-alpha = {
      source  = "hashicorp/kubernetes-alpha"
      version = "0.5.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.14.0"
    }
  }
}

locals {
  app_name           = "backend-app"
  core_infra         = data.terraform_remote_state.core_infra.outputs
  app_container_port = 3000
}

provider "google" {
  project = local.core_infra.gcp_project_id
  region  = local.core_infra.gcp_region
}

provider "kubernetes" {
  host                   = local.core_infra.kubernetes_url
  token                  = data.google_client_config.provider.access_token
  cluster_ca_certificate = local.core_infra.kubernetes_ca_certificate
}

provider "kubernetes-alpha" {
  host                   = local.core_infra.kubernetes_url
  token                  = data.google_client_config.provider.access_token
  cluster_ca_certificate = local.core_infra.kubernetes_ca_certificate
}
