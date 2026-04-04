terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.67.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.15.3"
    }
  }

}
provider "azurerm" {

  features {}
}


data "azurerm_kubernetes_cluster" "default" {
  depends_on          = [module.aks-cluster] # refresh cluster state before reading
  name                = var.cluster_name
  resource_group_name = var.cluster_name
}
provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.default.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.cluster_ca_certificate)
}
provider "helm" {
  kubernetes = {
    host                   = data.azurerm_kubernetes_cluster.default.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.cluster_ca_certificate)
  }
}


data "kubernetes_service_v1" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }
  # Ensure we don't try to read the IP before Helm finishes
  depends_on = [module.helm]
}
provider "argocd" {
  # We extract the IP from the LoadBalancer status
  server_addr = "${data.kubernetes_service_v1.argocd_server.status.0.load_balancer.0.ingress.0.ip}:443"

  username = "admin"
  password = var.ARGOCD_PASSWORD

  # Since LoadBalancers usually use self-signed certs by default
  insecure = true
}
