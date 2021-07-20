# VPCs

resource "google_compute_network" "main_vpc" {
  name                            = "main-vpc"
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = false
}


# Subnets

resource "google_compute_subnetwork" "gke_microservices_subnet" {
  name          = "gke-microservices-${var.gcp_region}-subnet"
  description   = "GKE microservices cluster subnet in ${var.gcp_region}"
  network       = google_compute_network.main_vpc.name
  ip_cidr_range = "10.0.0.0/24" # 254 nodes in the cluster
  secondary_ip_range = [
    {
      ip_cidr_range = "10.0.32.0/19" # Maximum of 16 pods per node
      range_name    = "pods-range"
    },
    {
      range_name    = "services-range"
      ip_cidr_range = "10.0.1.0/24" # 254 services in kubernetes
    }
  ]
  private_ip_google_access = true
}


# Gateways

resource "google_compute_router" "main_router" {
  name    = "main-router"
  network = google_compute_network.main_vpc.id
}

resource "google_compute_router_nat" "main_nat" {
  name                               = "main-nat"
  router                             = google_compute_router.main_router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}


# Reserved IP Addresses

resource "google_compute_global_address" "external_lb_ip" {
  name         = "external-load-balancer-address"
  address_type = "EXTERNAL"
}
