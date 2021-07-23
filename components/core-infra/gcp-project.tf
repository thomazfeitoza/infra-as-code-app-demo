resource "google_project" "project" {
  provider            = google.project-only
  name                = "DevOps"
  project_id          = "devops-${substr(uuid(), 0, 13)}"
  org_id              = var.gcp_organization_id
  billing_account     = var.gcp_billing_account
  auto_create_network = false
  lifecycle {
    ignore_changes = [
      project_id
    ]
  }
}

resource "google_project_service" "apis" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "logging.googleapis.com",
  ])
  service            = each.key
  disable_on_destroy = false
}
