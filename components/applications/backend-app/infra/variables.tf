variable "app_version" {
  type        = string
  description = "Container image version."
}

variable "min_replicas" {
  type        = number
  description = "Minimum number of pods for the deployment."
}

variable "max_replicas" {
  type        = number
  description = "Maximum number of pods for the deployment."
}

variable "autoscaling_cpu_average" {
  type        = number
  description = "Average CPU usage to trigger autoscaling."
}

variable "resources" {
  description = "Resources and requests definitions."
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits = object({
      cpu    = string
      memory = string
    })
  })
}

variable "env_vars" {
  type        = map(string)
  description = "Environment variables that will be injected into the containers."
  default     = {}
}
