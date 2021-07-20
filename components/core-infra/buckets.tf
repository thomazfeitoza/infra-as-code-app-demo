resource "google_storage_bucket" "frontend_app_bucket" {
  name                        = "frontend-app-${uuid()}"
  force_destroy               = true
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }
  lifecycle {
    ignore_changes = [
      name
    ]
  }
}
