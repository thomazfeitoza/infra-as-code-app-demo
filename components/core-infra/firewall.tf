resource "google_compute_firewall" "allow_ing_from_lb_to_gke_nodes_on_tcp" {
  name        = "allow-ing-from-lb-to-tag-on-tcp"
  description = "Allow GCP load balancer ingress traffic on GKE microservices cluster nodes."
  network     = google_compute_network.main_vpc.id
  direction   = "INGRESS"
  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]
  target_tags = [
    local.gke_nodes_default_network_tag
  ]
  allow {
    protocol = "tcp"
  }
}
