env = "prod"

region = "us-east-1"

network = {
  name            = "aws-network-prod"
  private_subnets = ["10.0.6.0/24", "10.0.7.0/24"]
  public_subnets  = ["10.0.8.0/24", "10.0.9.0/24"]
}

k8s_cluster = {
  name = "eks-cluster-prod"
}

node_group = {
  name          = "node-group-1-prod"
  instance_type = "t2.micro"
  min_size      = 1
  max_size      = 3
  desired_size  = 2
}
