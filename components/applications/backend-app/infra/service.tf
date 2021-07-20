resource "kubernetes_service" "app_service" {
  metadata {
    name      = local.app_name
    namespace = kubernetes_namespace.app_nampespace.metadata[0].name
    labels = {
      app = local.app_name
    }
    annotations = {
      "cloud.google.com/neg" = jsonencode({
        ingress = false
      })
    }
  }
  spec {
    type             = "NodePort"
    session_affinity = "None"
    selector = {
      app = kubernetes_deployment.app.metadata.0.labels.app
    }
    port {
      name        = "${local.app_name}-http"
      port        = 8080
      protocol    = "TCP"
      target_port = local.app_container_port
      node_port   = local.core_infra.backend_app_node_port
    }
  }
}
