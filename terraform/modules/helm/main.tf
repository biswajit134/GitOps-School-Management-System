resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
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

resource "local_file" "kubeconfig" {
  content  = var.kubeconfig
  filename = "${path.root}/kubeconfig"
}