

variable "location" {
  type    = string
}

resource "random_id" "cluster_name" {
  byte_length = 5
}

variable "cluster_name" {
  type = string
}

variable "node_count" {
  type = number

}

variable "vm_size" {
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
 