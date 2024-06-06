# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "env" {
  type        = string
  description = "Indicates whether the environment to use is development (dev) or production (prod)"
}

variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

# 28.05.2024 Soon: Added variable zone.
variable "zone" {
  type        = string
  description = "The default zone within the region."
}

# 28.05.2024 Soon: Added variable gcp_credentials.
/*
variable "gcp_credentials" {
  type = string
  sensitive = true
  description = "Google Cloud service account credentials"
}
*/

# 28.05.2024 Soon: Added attribute zone and credentials.
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
  # credentials = var.gcp_credentials
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}
