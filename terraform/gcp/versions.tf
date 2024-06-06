# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      # version = "4.74.0"
      # 20.05.2024 Soon: Changed to the latest version.
      # When running terraform init must add the -upgrade option (ONLY DO THIS ONCE) to use the
      # latest version. Otherwise, you will see an error message:
      # Error: Failed to query available provider packages
      # Could not retrieve the list of available versions for provider hashicorp/google: locked
      # provider registry.terraform.io/hashicorp/google 4.74.0 does not match configured version
      # constraint 5.29.1 -upgrade to allow selection of new versions. 
      version = "5.29.1"
    }
  }

  required_version = ">= 0.14"
}

