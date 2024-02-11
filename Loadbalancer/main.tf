resource "azurerm_lb" "todolb" {
  name                = "FrontendLoadBalancer"
  location            = data.azurerm_virtual_network.todovnet.location
  resource_group_name = var.rg_name
  sku                 = "Standard"
  sku_tier            = "Regional"

  frontend_ip_configuration {
    name                 = "frontendpip"
    public_ip_address_id = data.azurerm_public_ip.pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backendadresspool" {
  loadbalancer_id = azurerm_lb.todolb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "backend_adress_pool01" {
  for_each                = var.vms
  name                    = each.value.name
  backend_address_pool_id = azurerm_lb_backend_address_pool.backendadresspool.id
  ip_address              = data.azurerm_virtual_machine.vm[each.key].private_ip_address
  virtual_network_id      = data.azurerm_virtual_network.todovnet.id
}


resource "azurerm_lb_rule" "example" {
  loadbalancer_id                = azurerm_lb.todolb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontendpip"
  probe_id = azurerm_lb_probe.probe.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.backendadresspool.id]
  
}

resource "azurerm_lb_probe" "probe" {
  loadbalancer_id = azurerm_lb.todolb.id
  name            = "ssh-running-probe"
  port            = 22
}

