variable "namespace" {
  type        = string
  default     = "argocd"
  description = "Namespace for Argo CD"
}

variable "chart_version" {
  type        = string
  default     = "5.51.6"
  description = "Helm chart version for Argo CD"
}

