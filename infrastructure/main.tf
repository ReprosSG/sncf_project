# 1. Groupe de Ressources
resource "azurerm_resource_group" "rg" {
  name     = "rg-sncf-data-project"
  location = "francecentral" 
}

# 2. Compte de Stockage (Data Lake)
resource "azurerm_storage_account" "datalake" {
  name                     = "stsncfdataremy"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true 
}

# 3. Conteneur principal (datalake)
resource "azurerm_storage_data_lake_gen2_filesystem" "container_datalake" {
  name               = "datalake"
  storage_account_id = azurerm_storage_account.datalake.id
}

# 4. Architecture Medallion (Répertoires)
resource "azurerm_storage_data_lake_gen2_path" "bronze" {
  path               = "1-bronze"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.container_datalake.name
  storage_account_id = azurerm_storage_account.datalake.id
  resource           = "directory"
}

resource "azurerm_storage_data_lake_gen2_path" "silver" {
  path               = "2-silver"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.container_datalake.name
  storage_account_id = azurerm_storage_account.datalake.id
  resource           = "directory"
}

resource "azurerm_storage_data_lake_gen2_path" "gold" {
  path               = "3-gold"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.container_datalake.name
  storage_account_id = azurerm_storage_account.datalake.id
  resource           = "directory"
}

# Sous-dossier sncf_historique dans Bronze
resource "azurerm_storage_data_lake_gen2_path" "bronze_historique" {
  path               = "1-bronze/sncf_historique"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.container_datalake.name
  storage_account_id = azurerm_storage_account.datalake.id
  resource           = "directory"
  depends_on         = [azurerm_storage_data_lake_gen2_path.bronze]
}

# 5. Azure Data Factory
resource "azurerm_data_factory" "adf" {
  name                = "adf-sncf-project-remy"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 6. Azure Databricks
resource "azurerm_databricks_workspace" "databricks" {
  name                = "adb-sncf-project-remy"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "premium" 
}

# 7. Azure Key Vault (Nécessite de récupérer l'ID de ton locataire Azure)
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                       = "kv-sncf-project-remy"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
}