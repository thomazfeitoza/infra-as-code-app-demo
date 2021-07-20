output "gcp_project_id" {
  value = local.gcp_project_id
}

output "gcp_region" {
  value = var.gcp_region
}

output "app_domain" {
  value = var.app_domain
}

output "frontend_app_bucket_name" {
  value = google_storage_bucket.frontend_app_bucket.name
}

output "kubernetes_url" {
  value = "https://${google_container_cluster.microservices_cluster.endpoint}"
}

output "kubernetes_ca_certificate" {
  value = base64decode(google_container_cluster.microservices_cluster.master_auth.0.cluster_ca_certificate)
}

output "backend_app_node_port" {
  value = local.application_ports.backend_app
}
