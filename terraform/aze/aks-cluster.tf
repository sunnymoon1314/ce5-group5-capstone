# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_pet" "prefix" {}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  # 13.06.2024 Soon: Changed the resource group name to a fixed name.
  # name = "${random_pet.prefix.id}-rg"
  name = "aks-resource-group-rg"
  # location = "West US 2"
  location = "westus2"

  tags = {
    environment = "Demo"
  }
}

resource "azurerm_kubernetes_cluster" "default" {
  # 13.06.2024 Soon: Changed the cluster name to a fixed name.
  # name              = "${random_pet.prefix.id}-aks-${var.env}"
  name                = "aks-cluster-${var.env}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "${random_pet.prefix.id}-k8s"
  # 01.06.2024 Soon: Updated to use the recent version.
  # https://learn.microsoft.com/en-us/azure/aks/supported-kubernetes-versions?tabs=azure-cli#supported-version-list
  # kubernetes_version  = "1.26.3"
  kubernetes_version = "1.29"
  # kubernetes_version = "1.29.5"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  # 08.06.2024 Soon: Commented these so that we do not have to store secret information in Terraform.
  # service_principal {
  #  client_id     = var.appId
  #  client_secret = var.password
  # }

  # 08.06.20254 Soon: Since the HashiCorp stated one of either identity or service_principal blocks must be
  # specified, so I chose to use identity instead.
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster.
  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  tags = {
    environment = var.env
  }
}
