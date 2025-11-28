resource "helm_release" "jenkins" {
  name       = "jenkins"
  namespace  = var.namespace

  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = var.chart_version

  values = [
    file("${path.module}/values.yaml")
  ]

  create_namespace = true
}

