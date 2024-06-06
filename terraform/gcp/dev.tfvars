env = "dev"

# 04.06.2024 Soon: Updated to actual project_id.
# project_id = "<PROJECT_ID>"
# 05.06.2025 Soon: Replaced all us-west1 by us-east1.
project_id = "enhanced-option-423814-n0"
region     = "us-east1"
zone       = "us-east1-a"

# network = {
#  name            = "gke-network-dev"
#  subnetwork_name = "us-east1"
# }

# gke = {
#  name  = "gke-dev"
#  zones = ["us-east1-a"]
# }

node_pool = {
  name         = "node-pool-dev"
  machine_type = "e2-standard-2"
}

service_account = {
  name  = "gke-sa-dev"
  roles = []
}

# services = [
#   "cloudresourcemanager",
#   "compute",
#   "iam",
#   "servicenetworking",
#   "container"
# ]