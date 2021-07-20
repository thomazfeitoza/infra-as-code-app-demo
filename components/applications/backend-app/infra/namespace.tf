resource "kubernetes_namespace" "app_nampespace" {
  metadata {
    name = local.app_name
  }
}
