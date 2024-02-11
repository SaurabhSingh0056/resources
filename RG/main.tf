resource "azurerm_resource_group" "todo-rg" {
  for_each = var.resource
  name     = each.value.name
  location = each.value.location
}