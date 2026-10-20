
resource "azurerm_network_interface" "nics" {
  for_each = var.virtual_machines

  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_ids["subnet1"]
    private_ip_address_allocation = "Dynamic"
  }
}

data "azurerm_key_vault_secret" "admin_username" {
  for_each = var.virtual_machines
  name         = each.value.admin_username_secret_name
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "admin_password" {
  for_each = var.virtual_machines

  name         = each.value.admin_password_secret_name
  key_vault_id = var.key_vault_id
}

resource "azurerm_linux_virtual_machine" "vms" {
  for_each = var.virtual_machines

  name                = each.value.vm_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.vm_size

  network_interface_ids = [
    azurerm_network_interface.nics[each.key].id
  ]

  admin_username                  = data.azurerm_key_vault_secret.admin_username[each.key].value
  admin_password                  = data.azurerm_key_vault_secret.admin_password[each.key].value
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
