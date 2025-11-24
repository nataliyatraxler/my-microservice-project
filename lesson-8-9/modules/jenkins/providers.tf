terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
  }
}

# У спрощеній версії ми не підключаємось до реального кластера.
# Це "заглушки", щоб terraform validate проходив.

provider "kubernetes" {
  host                   = "https://dummy-k8s-api"
  client_certificate     = ""
  client_key             = ""
  cluster_ca_certificate = ""
}

provider "helm" {
  kubernetes {
    host                   = "https://dummy-k8s-api"
    client_certificate     = ""
    client_key             = ""
    cluster_ca_certificate = ""
  }
}

