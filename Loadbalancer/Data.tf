data "azurerm_public_ip" "pip" {
  name                = "frontendpip"
  resource_group_name = var.rg_name
}

data "azurerm_virtual_network" "todovnet" {
  name                = "Frontendvnet"
  resource_group_name = var.rg_name
}

data "azurerm_network_interface" "todonic" {
  for_each            = var.nic
  name                = each.value.name
  resource_group_name = var.rg_name
}

data "azurerm_virtual_machine" "vm" {
  for_each            = var.vms
  name                = each.value.name
  resource_group_name = var.rg_name
}