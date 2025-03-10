terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.54.0"
    }
  }
}

provider "azurerm" {
    
    subscription_id = "e3621159-0479-4391-86b0-7e2afae505de"
    client_id = "bc5b856a-4039-408a-98bc-fd376bd115d6"
    client_secret = "g9k8Q~RgQV_qHRuw6D_1uK4Lb.ZpVnBA~xwFTa~t"
    tenant_id = "3d3bcdb4-a71d-4e05-8f4d-f641c43a7f97"

    features {
      
    }
}