output "subnet_ids" {
  value = {
    for key, subnet in azurerm_subnet.subnet :
    key => subnet.id
  }
}