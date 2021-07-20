resource "kubernetes_config_map" "envs" {
  metadata {
    name      = "${local.app_name}-env-vars"
    namespace = kubernetes_namespace.app_nampespace.metadata[0].name
  }
  data = merge(var.env_vars, {
    SERVER_PORT = local.app_container_port
  })
}
