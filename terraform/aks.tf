resource "random_pet" "prefix" {
  prefix = "${var.rg_name}-aks-argocd"
}

resource "azurerm_resource_group" "aks" {
  name     = "${var.rg_name}-rg"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.rg_name}-aks"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = random_pet.prefix.id
  sku_tier            = "Free"  # Free tier for testing; change to "Paid" for production [web:4]

  default_node_pool {
    name                = "noodpool"
    node_count          = var.node_count
    vm_size             = var.vm_size  # Cost-effective for testing [web:5]
    os_disk_size_gb     = var.disk_size_gb
    # auto_scaling_enabled = true
    # min_count = 1
    # max_count = 10
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "kubenet"
    load_balancer_sku = "standard"
  }

}