resource "helm_release" "argo_cd" {
  name       = "argo-cd"
  namespace  = var.namespace

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version

  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}

resource "helm_release" "argo_cd_apps" {
  name      = "argo-cd-apps"
  namespace = var.namespace

  chart = "${path.module}/charts"

  values = [
    file("${path.module}/charts/values.yaml")
  ]

  depends_on = [
    helm_release.argo_cd
  ]
}

