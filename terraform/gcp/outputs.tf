output "gke_cluster_name" {
  value = module.gke.name
}

output "gke_cluster_endpoint" {
  description = "Endpoint for GKE control plane"
  value       = module.gke.endpoint
}

output "gke_cluster_region" {
  value = module.gke.region
}

output "gke_cluster_regional" {
  value = var.gke.regional
}

output "gke_cluster_zones" {
  value = module.gke.zones
}

output "gke_cluster_master_version" {
  value = module.gke.master_version
}

# 08.06.2024 Soon: Commented this.
# output "network_self_link" {
#   value = module.vpc.network_name
# }

# 08.06.2024 Soon: Commented this.
# output "subnets" {
#  value = module.vpc.subnets["${var.region}/${var.network.subnetwork_name}"].name
# }

# output "kubernetes_endpoint" {
#   sensitive = true
#   value     = module.gke.endpoint
# }

# output "client_token" {
#   sensitive = true
#   value     = base64encode(data.google_client_config.default.access_token)
# }

# output "ca_certificate" {
#       sensitive = true
#   value = module.gke.ca_certificate
# }

