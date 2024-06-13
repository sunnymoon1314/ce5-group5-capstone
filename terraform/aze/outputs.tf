# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.default.name
}

output "aks_cluster_version" {
  value = azurerm_kubernetes_cluster.default.kubernetes_version
}

output "aks_cluster_location" {
  value = azurerm_kubernetes_cluster.default.location
}

output "aks_cluster_resource_group_name" {
  value = azurerm_kubernetes_cluster.default.resource_group_name
}

output "aks_ingress_application_gateway" {
  description = "The azurerm_kubernetes_cluster's ingress_application_gateway block."
  value       = try(azurerm_kubernetes_cluster.default.ingress_application_gateway[0], null)
}

output "kubeconfig_command" {
  description = "Display the command that can be used to configure kubectl."
  value       = "az aks get-credentials --resource-group ${azurerm_kubernetes_cluster.default.resource_group_name} --name ${azurerm_kubernetes_cluster.default.name}"
}

# 08.06.2024 Soon: Commented this because it is sensitive information.
# output "aks_cluster_host" {
#  value = azurerm_kubernetes_cluster.default.kube_config.0.host
# }

# output "client_key" {
#   value = azurerm_kubernetes_cluster.default.kube_config.0.client_key
# }

# output "client_certificate" {
#   value = azurerm_kubernetes_cluster.default.kube_config.0.client_certificate
# }

# output "kube_config" {
#   value = azurerm_kubernetes_cluster.default.kube_config_raw
# }

# output "cluster_username" {
#   value = azurerm_kubernetes_cluster.default.kube_config.0.username
# }

# output "cluster_password" {
#   value = azurerm_kubernetes_cluster.default.kube_config.0.password
# }
