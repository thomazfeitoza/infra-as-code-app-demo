locals {
  gke_node_project_roles = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer"
  ]
}

# Service Accounts 

resource "google_service_account" "gke_node_account" {
  account_id   = "gke-node"
  display_name = "GKE node service account"
}


# Permissions

resource "google_project_iam_member" "gke_node_project_role" {
  for_each = { for role in local.gke_node_project_roles : role => role }
  role     = each.value
  member   = "serviceAccount:${google_service_account.gke_node_account.email}"
}

resource "google_storage_bucket_iam_member" "gke_node_read_access_on_container_registry" {
  bucket = google_container_registry.registry.id
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.gke_node_account.email}"
}

resource "google_storage_bucket_iam_member" "public_read_on_frontend_app_bucket" {
  bucket = google_storage_bucket.frontend_app_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
