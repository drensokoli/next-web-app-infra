module "resource_group" {
  source   = "./modules/resource_group"
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source              = "./modules/network"
  number              = "01"
  location            = module.resource_group.location
  prefix              = var.prefix
  resource_group_name = module.resource_group.name
}

module "virtual_machines-01" {
  source              = "./modules/virtual-machines"
  subnet_id           = module.network.subnet_id
  resource_group_name = module.resource_group.name
  prefix              = var.prefix
  number              = "01"
  location            = module.resource_group.location
  file_path           = "scripts/docker.sh"
}

module "virtual_machines-02" {
  source              = "./modules/virtual-machines"
  subnet_id           = module.network.subnet_id
  resource_group_name = module.resource_group.name
  prefix              = var.prefix
  number              = "02"
  location            = module.resource_group.location
  file_path           = "scripts/helm.sh"
}