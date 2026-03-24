
variable "cluster_name" {
  type = string
}

variable "kubeconfig" {
  type = string
}

variable "ARGOCD_PASSWORD" {
  type = string
}



# =====================================
# ========== Github Repo Config =======
# =====================================

variable "github_repo" {
  type = string
}

variable "branch" {
  type = string
}

variable "backend_manifestfile_path" {
  type = string
}

variable "frontend_manifestfile_path" {
  type = string
}