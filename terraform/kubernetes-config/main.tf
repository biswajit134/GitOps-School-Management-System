# Provider config
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.3"
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

provider "kubectl" {
  host                   = data.azurerm_kubernetes_cluster.default.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.cluster_ca_certificate)

}


# Kubernetes configaration 
resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace_v1" "ingress-nginx" {
  metadata {
    name = "ingress-nginx"
  }
}
resource "kubernetes_namespace_v1" "sms-backend" {
  metadata {
    name = "sms-backend"
  }
}

resource "kubernetes_namespace_v1" "sms-frontend" {
  metadata {
    name = "sms-frontend"
  }
}


# ArgoCD config
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace_v1.argocd.metadata.0.name
  version    = "9.4.15"  # Check latest on Artifact Hub [web:2]

  set =[{
    name  = "server.ingress.enabled"
    value = "false"  # Disable for now; add ingress separately
  },

  {
    name  = "server.service.type"
    value = "LoadBalancer"
  },

  {
    name  = "configs.secret.argocdServerAdminPassword"
    value = bcrypt("${var.ARGOCD_PASSWORD}", 10)  # Change this!
  }]
}

# ingress controller config

# resource "helm_release" "ingress-nginx" {
#   name       = "ingress-nginx"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   version    = "4.15.1"
#   namespace  = kubernetes_namespace_v1.ingress-nginx.metadata.0.name

#   set =[
#     {
#       name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
#       value = "/healthz"
#     },
#     {
#       name = "controller.enableSSLPassthrough"
#       value = "true"
#     }
#     ]
# }


resource "kubectl_manifest" "sms-backend-app" {
  yaml_body  = yamlencode( {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "sms-backend-app"
      namespace = "argocd" # Must match where ArgoCD is installed
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "${var.github_repo}"
        targetRevision = "${var.branch}"
        path           = "${var.backend_manifestfile_path}" # Folder inside your repo
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "sms-backend" # The namespace for your app
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  })

  depends_on = [helm_release.argocd]
}

resource "kubectl_manifest" "sms-frontend-app" {

yaml_body  = yamlencode( {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "sms-frontend-app"
      namespace = "argocd" # Must match where ArgoCD is installed
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "${var.github_repo}"
        targetRevision = "${var.branch}"
        path           = "${var.frontend_manifestfile_path}" # Folder inside your repo
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "sms-frontend" # The namespace for your app
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  })

  depends_on = [kubectl_manifest.sms-backend-app]
}


resource "local_file" "kubeconfig" {
  content  = var.kubeconfig
  filename = "${path.root}/kubeconfig"
}
