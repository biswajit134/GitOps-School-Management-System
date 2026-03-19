# AKS Cluster Details
output "aks_cluster_name" {
  value       = azurerm_kubernetes_cluster.aks.name
  description = "Name of the AKS cluster"
}

output "aks_kubeconfig_raw" {
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
  description = "Raw kubeconfig for kubectl"
}

output "aks_kubeconfig_host" {
  value       = azurerm_kubernetes_cluster.aks.kube_config.0.host
  description = "Kubeconfig host URL"
}

# Argo CD Load Balancer
output "argocd_server_lb_ip" {
  value       = try(kubernetes_manifest.guestbook_app.manifest.spec.source.repoURL != "" ? "Check: kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].ip}'" : null, null)
  description = "Argo CD server LoadBalancer IP (use kubectl if null)"
}

data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }
  depends_on = [helm_release.argocd]
}

output "argocd_lb_ip" {
  value = data.kubernetes_service.argocd_server.status.0.load_balancer.0.ingress.0.ip
}

# Admin Password (works if not custom bcrypt)
data "kubernetes_secret" "argocd_admin" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }
  depends_on = [helm_release.argocd]
}

output "argocd_admin_password" {
  value       = base64decode(data.kubernetes_secret.argocd_admin.data.0["password"])
  sensitive   = true
  description = "Argo CD admin password"
}

# Argo CD Application Status
output "argocd_app_url" {
  value = "https://${data.kubernetes_service.argocd_server.status.0.load_balancer.0.ingress.0.ip}"
}

output "sms_service_ip" {
  value = "Deploy sms manifests to Git → Check: kubectl get svc sms -n default -o jsonpath='{.status.loadBalancer.ingress[0].ip}'"
  description = "SMS app LB IP after GitOps sync"
}