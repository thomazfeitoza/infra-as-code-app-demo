resource "kubernetes_deployment" "app" {
  wait_for_rollout = true

  metadata {
    name      = local.app_name
    namespace = kubernetes_namespace.app_nampespace.metadata[0].name
    labels = {
      app = local.app_name
    }
  }
  spec {
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = "25%"
        max_unavailable = "0"
      }
    }
    selector {
      match_labels = {
        app = local.app_name
      }
    }
    template {
      metadata {
        labels = {
          app     = local.app_name
          version = var.app_version
        }
        annotations = {
          "cluster-autoscaler.kubernetes.io/safe-to-evict" : true
        }
      }
      spec {
        service_account_name             = kubernetes_service_account.app_account.metadata.0.name
        termination_grace_period_seconds = 30

        container {
          image = "gcr.io/${local.core_infra.gcp_project_id}/${local.app_name}:${var.app_version}"
          name  = local.app_name
          resources {
            requests = var.resources.requests
            limits   = var.resources.limits
          }
          port {
            container_port = local.app_container_port
          }
          security_context {
            privileged                = false
            read_only_root_filesystem = true
          }
          env_from {
            config_map_ref {
              name = kubernetes_config_map.envs.metadata[0].name
            }
          }
          startup_probe {
            http_get {
              path = "/health"
              port = local.app_container_port
            }
            initial_delay_seconds = 2
            failure_threshold     = 10
            period_seconds        = 5
            success_threshold     = 1
            timeout_seconds       = 3
          }
          readiness_probe {
            http_get {
              path = "/health"
              port = local.app_container_port
            }
            period_seconds    = 10
            timeout_seconds   = 3
            failure_threshold = 3
            success_threshold = 1
          }
          liveness_probe {
            http_get {
              path = "/health"
              port = local.app_container_port
            }
            period_seconds    = 10
            timeout_seconds   = 3
            failure_threshold = 3
            success_threshold = 1
          }
        }

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 1
              pod_affinity_term {
                topology_key = "kubernetes.io/hostname"
                label_selector {
                  match_labels = {
                    app     = local.app_name
                    version = var.app_version
                  }
                }
              }
            }
          }
        }

      }
    }
  }
}
