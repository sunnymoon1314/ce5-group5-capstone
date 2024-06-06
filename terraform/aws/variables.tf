# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "env" {
  type        = string
  description = "Indicates whether the environment to use is development (dev) or production (prod)"
}

variable "resource_prefix" {
  type        = string
  description = "Short code to tag the resources created by ce5/group5"
  # 01.04.2024 Soon: Updated the region from us-east-2 to us-east-1.
  default = "ce5-gp5"
}

variable "region" {
  type        = string
  description = "AWS default region"
  # 01.04.2024 Soon: Updated the region from us-east-2 to us-east-1.
  default = "us-east-1"
}

variable "network" {
  type = object({
    name            = string
    private_subnets = optional(list(string), ["10.0.1.0/24", "10.0.2.0/24"])
    public_subnets  = optional(list(string), ["10.0.4.0/24", "10.0.5.0/24"])
  })
}

variable "k8s_cluster" {
  type = object({
    name = optional(string, "eks")
  })
}

variable "node_group" {
  type = object({
    name          = optional(string, "node-group-dev")
    instance_type = optional(string, "t2.micro")
    min_size      = optional(number, 1)
    max_size      = optional(number, 3)
    desired_size  = optional(number, 2)
  })
}