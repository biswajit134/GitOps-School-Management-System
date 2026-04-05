
# ==================================================
# ========== Variables for AKS Cluster Creation =======
# ==================================================
variable "location" {
  type    = string
  default = "central india"
}

resource "random_id" "cluster_name" {
  byte_length = 5
}

variable "cluster_name" {
  type    = string
  default = "sms-cluster"
}

variable "node_count" {
  type    = number
  default = 1

}

variable "workers_count" {
  type    = number
  default = 1
}

variable "vm_size" {
  type    = string
  default = "Standard_A2_v2"
}
variable "ARGOCD_PASSWORD" {
  type    = string
  default = "biswajit123"
}

# =====================================
# ========== Kubernetes Namespace =======
# =====================================
variable "argocd_namespace" {
  type    = string
  default = "argocd"
}



# =====================================
# ========== Github Repo Config =======
# =====================================

variable "github_repo" {
  type    = string
  default = "https://github.com/biswajit134/GitOps-School-Management-System.git"
}

variable "branch" {
  type    = string
  default = "main"
}

variable "backend_manifestfile_path" {
  type    = string
  default = "app-helm/sms-backend"
}

variable "frontend_manifestfile_path" {
  type    = string
  default = "app-helm/sms-frontend"
}
 