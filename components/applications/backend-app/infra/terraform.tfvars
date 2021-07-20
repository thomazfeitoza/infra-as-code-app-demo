min_replicas            = 2
max_replicas            = 5
autoscaling_cpu_average = 70
resources = {
  requests = {
    cpu    = "200m"
    memory = "256Mi"
  }
  limits = {
    cpu    = null
    memory = "512Mi"
  }
}
app_version = "latest"
