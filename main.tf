module "resource_group" {
  source   = "./modules/resource_group"
  name     = var.resource_group_name
  location = var.location
}

module "storage_account" {
  source              = "./modules/storage_account"
  depends_on          = [module.resource_group]
  name                = var.storage_account_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
}

module "aks_cluster" {
  source              = "./modules/aks_cluster"
  depends_on          = [module.resource_group]
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  cluster_name        = var.aks_cluster_name
  kubernetes_version  = "1.28.9"
  system_node_count   = var.aks_node_count
  node_resource_group = module.resource_group.name
}