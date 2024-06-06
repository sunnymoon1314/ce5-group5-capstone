# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # 01.06.2024 Soon: Updated to use the latest version.
      version = "3.67.0"
      # version = "3.106.0"
    }
  }

  required_version = ">= 0.14"
}

