# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_version" {
  value = module.eks.cluster_version
}

output "eks_cluster_region" {
  value = var.region
}

output "eks_cluster_security_group_id" {
  description = "Security group ids attached to the EKS control plane"
  value       = module.eks.cluster_security_group_id
}

output "kubeconfig_command" {
  description = "Display the command that can be used to configure kubectl."
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
}
