resource "kubernetes_service_account" "app_account" {
  metadata {
    name      = local.app_name
    namespace = kubernetes_namespace.app_nampespace.metadata[0].name
  }
}

resource "google_service_account" "app_google_account" {
  account_id   = local.app_name
  display_name = "${local.app_name} service account"
}

resource "google_service_account_iam_member" "k8s_google_impersonate" {
  service_account_id = google_service_account.app_google_account.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${local.core_infra.gcp_project_id}.svc.id.goog[${kubernetes_namespace.app_nampespace.metadata[0].name}/${kubernetes_service_account.app_account.metadata.0.name}]"
}

resource "google_project_iam_member" "trace_agent" {
  role   = "roles/cloudtrace.agent"
  member = "serviceAccount:${google_service_account.app_google_account.email}"
}

resource "google_project_iam_member" "metric_writer" {
  role   = "roles/monitoring.metricWriter"
  member = "serviceAccount:${google_service_account.app_google_account.email}"
}
