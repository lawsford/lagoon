terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.config_path
}

# provider "kubectl" {
#     config_path = var.config_path
# }

data "http" "nginx_controller_raw" {
    url = "https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml"
}

data "kubectl_file_documents" "nginx_controller_manifests" {
  content = data.http.nginx_controller_raw.response_body
}

resource "kubectl_manifest" "nginx_controller" {
    for_each  = data.kubectl_file_documents.nginx_controller_manifests.manifests
    yaml_body = each.value
}

resource "kubernetes_namespace" "playground" {
  metadata {
    name = "playground"
  }
}

resource "kubernetes_manifest" "test_app_pod" {
 manifest = yamldecode(file("${path.module}/resources/test-pod/pod.yaml"))
}

resource "kubernetes_manifest" "test_app_svc" {
 manifest = yamldecode(file("${path.module}/resources/test-pod/svc.yaml"))
}

resource "kubernetes_manifest" "test_app_ing" {
 manifest = yamldecode(file("${path.module}/resources/test-pod/ing.yaml"))
}