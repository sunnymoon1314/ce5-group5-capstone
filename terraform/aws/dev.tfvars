env = "dev"

region = "us-east-1"

network = {
  name            = "aws-network-dev"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24"]
}

k8s_cluster = {
  name = "eks-cluster-dev"
}

node_group = {
  name          = "node-group-1-dev"
  instance_type = "t2.micro"
  min_size      = 1
  max_size      = 2
  desired_size  = 1
}
