env = "prod"

# 04.06.2024 Soon: Updated to actual project_id.
# project_id = "<PROJECT_ID>"
# 05.06.2025 Soon: Replaced all us-central1 by us-east1.
project_id = "enhanced-option-423814-n0"
region     = "us-east1"
zone       = "us-east1-a"

# network = {
#  name                = "gke-network-prod"
#  subnetwork_name     = "us-east1"
#  nodes_cidr_range    = "10.128.0.0/20"
#  pods_cidr_range     = "10.4.0.0/14"
#  services_cidr_range = "10.8.0.0/20"
# }

# gke = {
#  name     = "gke-prod"
#  regional = true
#  zones    = ["us-east1-b", "us-east1-c", "us-east1-f"]
# }

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
  name  = "prod-sa"
  roles = []
}