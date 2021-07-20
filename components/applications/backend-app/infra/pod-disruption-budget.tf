resource "kubernetes_pod_disruption_budget" "app_pdb" {
  metadata {
    name      = "${local.app_name}-pdb"
    namespace = kubernetes_namespace.app_nampespace.metadata[0].name
  }
  spec {
    max_unavailable = "1"
    selector {
      match_labels = {
        app = local.app_name
      }
    }
  }
}
