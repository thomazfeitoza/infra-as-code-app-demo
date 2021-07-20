locals {
  gke_nodes_default_network_tag = "gke-microservices-cluster-node"
}

# Cluster 

resource "google_container_cluster" "microservices_cluster" {
  provider                  = google-beta
  name                      = "microservices-cluster"
  location                  = data.google_compute_zones.available.names[0]
  remove_default_node_pool  = true
  initial_node_count        = 1
  network                   = google_compute_network.main_vpc.name
  subnetwork                = google_compute_subnetwork.gke_microservices_subnet.name
  default_max_pods_per_node = 16
  enable_tpu                = false
  networking_mode           = "VPC_NATIVE"
  min_master_version        = "1.19"

  release_channel {
    channel = "STABLE"
  }

  workload_identity_config {
    identity_namespace = "${local.gcp_project_id}.svc.id.goog"
  }

  private_cluster_config {
    enable_private_nodes    = false
    enable_private_endpoint = false
    master_global_access_config {
      enabled = true
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.gke_microservices_subnet.secondary_ip_range[0].range_name
    services_secondary_range_name = google_compute_subnetwork.gke_microservices_subnet.secondary_ip_range[1].range_name
  }

  cluster_autoscaling {
    enabled             = false
    autoscaling_profile = "BALANCED"
  }
}


# Node Pools

resource "google_container_node_pool" "default_pool" {
  name       = "default-pool-${substr(uuid(), 0, 8)}"
  location   = google_container_cluster.microservices_cluster.location
  cluster    = google_container_cluster.microservices_cluster.name
  node_count = 2

  node_config {
    image_type      = "cos_containerd"
    service_account = google_service_account.gke_node_account.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    machine_type = "e2-custom-2-2048"
    preemptible  = false
    disk_size_gb = 10
    disk_type    = "pd-balanced"
    metadata = {
      disable-legacy-endpoints = "true"
    }
    tags = [
      local.gke_nodes_default_network_tag
    ]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 2
    max_node_count = 10
  }

  lifecycle {
    ignore_changes = [
      name,
      node_count
    ]
    create_before_destroy = true
  }
}
