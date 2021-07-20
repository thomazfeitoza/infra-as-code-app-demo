locals {
  application_ports = {
    backend_app = 32174
  }
  load_balancer_instance_group = google_container_node_pool.default_pool.instance_group_urls[0]
  instance_group_url_parts     = split("/", local.load_balancer_instance_group)
}

resource "google_compute_health_check" "gke_healthcheck" {
  provider           = google-beta
  name               = "gke-healthcheck"
  check_interval_sec = 5
  timeout_sec        = 3
  tcp_health_check {
    port = "10256"
  }
}

resource "google_compute_instance_group_named_port" "backend_app_port" {
  group = local.instance_group_url_parts[10]
  name  = "backend-app-service"
  port  = local.application_ports.backend_app
  zone  = local.instance_group_url_parts[8]
}

resource "google_compute_backend_service" "backend_app" {
  provider              = google-beta
  name                  = "backend-app"
  load_balancing_scheme = "EXTERNAL"
  protocol              = "HTTP"
  timeout_sec           = 60
  health_checks         = [google_compute_health_check.gke_healthcheck.id]
  port_name             = google_compute_instance_group_named_port.backend_app_port.name

  backend {
    group                        = replace(local.load_balancer_instance_group, "instanceGroupManagers", "instanceGroups")
    balancing_mode               = "UTILIZATION"
    capacity_scaler              = 1
    max_connections_per_endpoint = 0
    max_connections_per_instance = 0
    max_rate                     = 0
    max_rate_per_endpoint        = 0
    max_rate_per_instance        = 0
    max_utilization              = 0.8
  }
}

resource "google_compute_backend_bucket" "frontend_app" {
  provider    = google-beta
  name        = "frontend-app"
  description = "Backend bucket for the frontend application."
  bucket_name = google_storage_bucket.frontend_app_bucket.name
  enable_cdn  = true

  # reducing ttl to avoid receiving cached content after deploying the frontend app
  cdn_policy {
    client_ttl  = 30
    max_ttl     = 30
    default_ttl = 30
  }
}

resource "google_compute_global_forwarding_rule" "app_rule" {
  name       = "application-rule"
  target     = google_compute_target_https_proxy.app_proxy.id
  port_range = "443"
  ip_address = google_compute_global_address.external_lb_ip.address
}

resource "google_compute_target_https_proxy" "app_proxy" {
  name             = "application-https-proxy"
  url_map          = google_compute_url_map.app_url_map.id
  ssl_certificates = [google_compute_ssl_certificate.app_certificate.id]
}

resource "google_compute_url_map" "app_url_map" {
  name = "application-url-map"

  # Redirecting to google.com to prevent direct access using load balancer IP.
  default_url_redirect {
    host_redirect = "google.com"
    strip_query   = true
    path_redirect = "/"
  }

  host_rule {
    hosts        = [var.app_domain]
    path_matcher = "app"
  }

  path_matcher {
    name            = "app"
    default_service = google_compute_backend_bucket.frontend_app.id

    path_rule {
      paths   = ["/api/*"]
      service = google_compute_backend_service.backend_app.id
    }
  }
}

