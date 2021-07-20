resource "kubernetes_horizontal_pod_autoscaler" "autoscaler" {
  metadata {
    name      = "${local.app_name}-hpa"
    namespace = kubernetes_namespace.app_nampespace.metadata[0].name
  }

  spec {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.app.metadata[0].name
    }

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = var.autoscaling_cpu_average
        }
      }
    }
  }
}
