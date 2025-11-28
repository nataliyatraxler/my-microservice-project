output "argocd_namespace" {
  value = var.namespace
}

output "argocd_release_name" {
  value = helm_release.argo_cd.name
}

