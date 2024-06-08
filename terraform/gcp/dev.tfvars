# 04.06.2024 Soon: Updated to actual project_id.
# project_id = "<PROJECT_ID>"
project_id = "enhanced-option-423814-n0"
region     = "us-east1"
zone       = "us-east1-b"

network = {
  name            = "gke-network-dev"
  subnetwork_name = "us-east1"
}

gke = {
  name  = "gke-cluster-dev"
  zones = ["us-east1-b"]
}

node_pool = {
  name         = "node-pool-dev"
  machine_type = "e2-standard-2"
}

service_account = {
  name  = "sa-dev"
  roles = []
}

# services = [
#   "cloudresourcemanager",
#   "compute",
#   "iam",
#   "servicenetworking",
#   "container"
# ]