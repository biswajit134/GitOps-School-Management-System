module "aks-cluster" {
  source        = "./modules/aks-cluster"
  cluster_name  = var.cluster_name
  location      = var.location
  node_count    = var.node_count
  vm_size       = var.vm_size
  workers_count = var.workers_count
}

module "kubernetes_namespace_argocd" {
  depends_on           = [module.aks-cluster]
  source               = "./modules/kubernetes"
  kubernetes_namespace = var.argocd_namespace
}

module "helm" {
  depends_on      = [module.kubernetes_namespace_argocd, module.aks-cluster]
  source          = "./modules/helm"
  ARGOCD_PASSWORD = var.ARGOCD_PASSWORD
  kubeconfig      = data.azurerm_kubernetes_cluster.default.kube_config_raw
}




module "kubernetes_namespace_backend" {
  depends_on           = [module.aks-cluster]
  source               = "./modules/kubernetes"
  kubernetes_namespace = "sms-backend"
}

module "kubernetes_namespace_frontend" {
  depends_on           = [module.aks-cluster]
  source               = "./modules/kubernetes"
  kubernetes_namespace = "sms-frontend"
}
module "argocd" {
  depends_on                 = [module.helm, module.kubernetes_namespace_backend, module.kubernetes_namespace_frontend]
  source                     = "./modules/argocd"
  github_repo                = var.github_repo
  branch                     = var.branch
  backend_manifestfile_path  = var.backend_manifestfile_path
  frontend_manifestfile_path = var.frontend_manifestfile_path
}
