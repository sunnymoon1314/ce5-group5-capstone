terraform {
  backend "azurerm" {
    resource_group_name  = "NetworkWatcherRG"
    storage_account_name = "bunnyvalley"
    container_name       = "tfstate"
    key                  = "azure.terraform.tfstate"
    # 08.06.2024 Soon: Refer to secrets.tfvars for the values.
    # client_id            = "..."
    # subscription_id      = "..."
    # tenant_id            = "..."
  }
}
