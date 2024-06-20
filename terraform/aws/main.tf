# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.region
}

# Filter out local zones, which are not currently supported 
# with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  # 13.06.2024 Soon: Changed the cluster name to a fixed name.
  # cluster_name = "${var.k8s_cluster.name}-${random_string.suffix.result}"
  cluster_name = var.k8s_cluster.name
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "${var.resource_prefix}-vpc"

  cidr = "10.0.0.0/16"
  # 02.06.2024 Soon: Changed the number of availability zones from 3 to 2.
  # This is to reduce the time required to provision the cluster. Unless
  # you do not mind waiting for at least 16 minutes for every test iteration.
  # azs  = slice(data.aws_availability_zones.available.names, 0, 3)
  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  # 02.06.2024 Soon: Changed the number of subnets from 3 to 2.
  # This is to reduce the time required to provision the cluster. Unless
  # you do not mind waiting for at least 16 minutes for every test iteration.
  # azs  = slice(data.aws_availability_zones.available.names, 0, 3)
  # private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  # public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  private_subnets = var.network.private_subnets
  public_subnets  = var.network.public_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name = local.cluster_name
  # 08.06.2024 Soon: Updated the Kubernetes version from 1.27 to 1.29.
  cluster_version = "1.29"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "${var.node_group.name}"

      # 28.05.2024 Soon: Change t3.small to t2.micro.
      instance_types = [var.node_group.instance_type]

      min_size     = var.node_group.min_size
      max_size     = var.node_group.max_size
      desired_size = var.node_group.desired_size
    }

    # 02.06.2024 Soon: Commented the second node-group so as to
    # reduce the time required to provision the cluster. Unless
    # you do not mind waiting for at least 16 minutes for every
    # test iteration.
    /*
    two = {
      name = "node-group-2"

      # 28.05.2024 Soon: Change t3.small to t2.micro.
      instance_types = ["t2.micro"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
    */
  }
}


# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.7.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

/*
# 31.05.2024 Soon: Commented out the aws_eks_addon resource because it takes almost 20 minutes
# to create!!!
resource "aws_eks_addon" "ebs-csi" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  # 31.05.2024 Soon: Updated the ebs-csi driver to the latest version.
  # For more details on the ebs-csi driver update, please refer to:
  # https://docs.aws.amazon.com/eks/latest/userguide/managing-ebs-csi.html#updating-ebs-csi-eks-add-on
  # addon_version            = "v1.20.0-eksbuild.1"
  addon_version              = "v1.31.0-eksbuild.1"
  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
  tags = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"
  }
}
*/