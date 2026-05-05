location = "Central India"

resource_groups = {
  hub_rg   = "rg-hub-dev"
  spoke_rg = "rg-spoke-dev"
}

vnets = {
  hub = {
    name          = "vnet-hub-dev"
    address_space = ["10.0.0.0/16"]
  }

  spoke = {
    name          = "vnet-spoke-dev"
    address_space = ["10.1.0.0/16"]
  }
}

subnets = {
  hub = {
    AzureBastionSubnet  = "10.0.1.0/24"
    AzureFirewallSubnet = "10.0.2.0/24"
  }

  spoke = {
    aks         = "10.1.1.0/24"
    appgw       = "10.1.2.0/24"
    private_ep  = "10.1.3.0/24"
    db          = "10.1.4.0/24"
  }
}

# STORAGE
storage_accounts = {
  sa1 = {
    name                     = "stprashantdev123"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

# KEYVAULT
keyvaults = {
  kv1 = {
    name     = "kv-prashant-dev-123"
    sku_name = "standard"
  }
}

# DATABASE
databases = {
  pg1 = {
    name           = "pg-prashant-dev"
    sku_name       = "B_Standard_B1ms"
    storage_mb     = 32768
    version        = "13"
    admin_user     = "pgadmin"
    admin_password = "StrongPassword@123"
  }
}

tenant_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}