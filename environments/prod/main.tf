module "resource_groups" {
  source          = "../../modules/azurerm_rg"
  resource_groups = var.resource_groups
}
module "virtual_networks" {
  source           = "../../modules/azurerm_vnet"
  virtual_networks = var.virtual_networks
}

module "subnets" {
  source  = "../../modules/azurerm_subnet"
  depends_on = [module.virtual_networks]
  subnets = var.subnets
}

module "virtual_machines" {
    depends_on = [module.subnets]
  source           = "../../modules/azurerm_vm"
  virtual_machines = var.virtual_machines
  subnet_ids       = module.subnets.subnet_ids
  key_vault_id     = var.key_vault_id
}

module "bastions" {
    depends_on = [module.subnets]
  source     = "../../modules/azurerm_bastion"
  bastions   = var.bastions
  subnet_ids = module.subnets.subnet_ids
}
