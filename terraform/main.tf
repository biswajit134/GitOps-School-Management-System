
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.42"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
    }

     kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.19.0"
    }

    
  }
    
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


provider "kubectl" {
  host                   = data.azurerm_kubernetes_cluster.default.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.cluster_ca_certificate)

}



provider "azurerm" {

  features {}
}

module "aks-cluster" {
  source       = "./aks-cluster"
  cluster_name = var.cluster_name
  location     = var.location
  node_count   = var.node_count
  vm_size      = var.vm_size
}

module "kubernetes-config" {
  depends_on          = [module.aks-cluster]
  source              = "./kubernetes-config"
  cluster_name        = var.cluster_name
  ARGOCD_PASSWORD     = var.ARGOCD_PASSWORD


  # Github Repo Config
  github_repo                   = var.github_repo
  branch                        = var.branch
  backend_manifestfile_path     = var.backend_manifestfile_path
  frontend_manifestfile_path    = var.frontend_manifestfile_path

  kubeconfig   = data.azurerm_kubernetes_cluster.default.kube_config_raw
}
