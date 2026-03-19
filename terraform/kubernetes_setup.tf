#Create Argo CD namespace and install Argo CD using Helm
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# Create sms-backend namespace for sms-backend-app
resource "kubernetes_namespace" "sms-backend" {
  metadata {
    name = "sms-backend"
  }
}

# Create sms-frontend namespace for sms-frontend-app
resource "kubernetes_namespace" "sms-frontend" {
  metadata {
    name = "sms-frontend"
  }
}


# Install Argo CD using Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = "6.9.1"  # Check latest on Artifact Hub [web:2]

  set {
    name  = "server.ingress.enabled"
    value = "false"  # Disable for now; add ingress separately
  }

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = bcrypt(var.ARGOCD_PASSWORD, 10)  # Change this!
  }
}

# Deploy the sms-backend-app application using Argo CD
resource "kubernetes_manifest" "sms_backend_app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "sms-backend-app"
      namespace = "argocd"
      finalizers = ["resources-finalizer.argocd.argoproj.io"]
    }
    spec = {
      project = "default"
      
      source = {
        repoURL        = "https://github.com/biswajit134/GitOps-School-Management-System.git"  # Github repo URL
        targetRevision = "devops"
        path           = "k8s_manifest/backend_manifest"
      }
      
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "sms-backend"
      }
      
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  }
  
  depends_on = [helm_release.argocd]
}

# Deploy the sms-frontend-app application using Argo CD
resource "kubernetes_manifest" "sms_frontend_app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "sms-frontend-app"
      namespace = "argocd"
      finalizers = ["resources-finalizer.argocd.argoproj.io"]
    }
    spec = {
      project = "default"
      
      source = {
        repoURL        = "https://github.com/biswajit134/GitOps-School-Management-System.git"  # Github repo URL
        targetRevision = "devops"
        path           = "k8s_manifest/frontend_manifest"
      }
      
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "sms-frontend"
      }
      
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  }
  
  depends_on = [helm_release.argocd, kubernetes_manifest.sms_backend_app]  # Ensure backend app is deployed first
}

