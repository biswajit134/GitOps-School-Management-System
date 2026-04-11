terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.42"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.15.3"
    }
  }
}