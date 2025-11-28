variable "namespace" {
  type        = string
  default     = "jenkins"
  description = "Namespace for Jenkins"
}

variable "chart_version" {
  type        = string
  default     = "5.0.3"
  description = "Helm chart version for Jenkins"
}

