terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network" "aksnet" {
  name                = "aksnet"
  address_space       = ["192.168.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "akssubnet" {
  name                 = "akssubnet01"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.aksnet.name
  address_prefixes     = ["192.168.1.0/24"]
}

resource "azurerm_subnet" "akssubnet-vkube" {
  name                 = "akssubnetvkube"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.aksnet.name
  address_prefixes     = ["192.168.100.0/24"]
}

resource "azurerm_kubernetes_cluster" "k8squickstart" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.name}-dns01"

  network_profile {
    network_plugin = "azure"
  }

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = "Standard_A2_v2"
    vnet_subnet_id = azurerm_subnet.akssubnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}