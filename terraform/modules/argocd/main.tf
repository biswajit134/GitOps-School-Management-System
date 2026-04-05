# =============================================================================
# ArgoCD Backend Application Definitions
# =============================================================================
resource "argocd_application" "sms-backend-app" {

  metadata {
    name      = "sms-backend-app"
    namespace = "argocd"  # Assuming ArgoCD is installed in the 'argocd' namespace
  }

  cascade = false # disable cascading deletion
  wait    = true

  spec {
    project = "default"

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "sms-backend"  # This should match the namespace where your backend manifests will be deployed
    }

    source {
      repo_url        = var.github_repo
      path            = var.backend_manifestfile_path
      target_revision = var.branch
      helm {
        release_name = "sms-backend"
      }
    }

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }
      # Only available from ArgoCD 1.5.0 onwards
      sync_options = ["Validate=false"]
      retry {
        limit = "5"
        backoff {
          duration     = "30s"
          max_duration = "2m"
          factor       = "2"
        }
      }
    }
  }
}


# =============================================================================
# ArgoCD Frontend Application Definitions
# =============================================================================
resource "argocd_application" "sms-frontend-app" {

  metadata {
    name      = "sms-frontend-app"
    namespace = "argocd"  # Assuming ArgoCD is installed in the 'argocd' namespace
  }

  cascade = false # disable cascading deletion
  wait    = true

  spec {
    project = "default"

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "sms-frontend"  # This should match the namespace where your frontend manifests will be deployed
    }

    source {
      repo_url        = var.github_repo
      path            = var.frontend_manifestfile_path
      target_revision = var.branch
      helm {
        release_name = "sms-frontend"
      }
    }

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }
      # Only available from ArgoCD 1.5.0 onwards
      sync_options = ["Validate=false"]
      retry {
        limit = "5"
        backoff {
          duration     = "30s"
          max_duration = "2m"
          factor       = "2"
        }
      }
    }
  }
}