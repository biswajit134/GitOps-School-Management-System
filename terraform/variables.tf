# Provider block to specify Azure as the provider
variable "SUBSCRIPTION_ID" {
    description = "Azure Subscription ID"
    type        = string
    sensitive = true
}

variable "CLIENT_ID" {
    description = "Azure Client ID"
    type        = string
    sensitive = true
}

variable "CLIENT_SECRET" {
    description = "Azure Client Secret"
    type        = string
    sensitive = true
}


variable "TENANT_ID" {
    description = "Azure Tenant ID"
    type        = string
    sensitive = true
}


#For AKS cluster setup and configuration
variable "rg_name" {
  description = "Name for resource group"
  type = string
}

variable "location" {
  description = "Azure region for resources"
  type = string
  
}

variable "node_count" {
  description = "Number of nodes in AKS cluster"
  type = number
}

variable "vm_size" {
  description = "Size of the VMs in the AKS cluster"
  type = string
}

variable "disk_size_gb" {
  description = "Disk size for AKS nodes in GB"
  type = number
}

# In kubernetes_setup.tf, we will use these variables to configure the AKS cluster and Argo CD deployment.
variable "ARGOCD_PASSWORD" {
  description = "Argocd Password"
  type = string
}