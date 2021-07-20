data "cloudflare_zones" "application_zone" {
  filter {
    name = var.app_domain
  }
}

resource "cloudflare_record" "application_record" {
  zone_id = data.cloudflare_zones.application_zone.zones[0].id
  name    = var.app_domain
  value   = google_compute_global_address.external_lb_ip.address
  type    = "A"
  proxied = true
}
