# 04.06.2024 Soon: Updated to actual project_id.
# project_id = "<PROJECT_ID>"
project_id = "enhanced-option-423814-n0"
region     = "us-central1"
zone       = "us-central1-a"

network = {
  name                = "gke-network-prod"
  subnetwork_name     = "us-central1"
  nodes_cidr_range    = "10.128.0.0/20"
  pods_cidr_range     = "10.4.0.0/14"
  services_cidr_range = "10.8.0.0/20"
}

gke = {
  name     = "gke-cluster-prod"
  regional = true
  zones    = ["us-central1-b", "us-central1-c", "us-central1-f"]
}

node_pool = {
  name               = "node-pool-prod"
  machine_type       = "e2-medium"
  disk_size_gb       = 20
  spot               = false
  initial_node_count = 2
  max_count          = 5
}

services = [
  "cloudresourcemanager",
  "compute",
  "iam",
  "servicenetworking",
  "container"
]

service_account = {
  name  = "sa-prod"
  roles = []
}
