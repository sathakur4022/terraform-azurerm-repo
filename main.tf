resource "azurerm_resource_group" "RG-Prod" {
  name     = local.rgname
  location = var.location-info
  tags = local.commtag
  }
resource "random_string" "myrandom" {
  length  = 4
  special = false
  upper   = false
}
resource "azurerm_storage_account" "prodstorage" {
  name                     = "prodsa${random_string.myrandom.id}"
  resource_group_name      = local.rgname
  location                 = var.location-info
  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_kind             = "StorageV2"
  
 }
resource "azurerm_virtual_network" "Vnet-01" {
  name                = "ProdVnet"
  address_space       = ["10.100.0.0/16"]
  location            = azurerm_resource_group.RG-Prod.location
  resource_group_name = local.rgname
  
 }
resource "azurerm_subnet" "Subnet01" {
  name                 = "Prodsubnet-01"
  resource_group_name  = local.rgname
  virtual_network_name = azurerm_virtual_network.Vnet-01.name
  address_prefixes     = ["10.100.1.0/24"]
 }
resource "azurerm_public_ip" "publicIP" {
  for_each = var.VMmap
  name                = "mypublicIP-${each.value.vmname}"
  resource_group_name = local.rgname
  location            = var.location-info
  allocation_method   = "Static"
  sku                 = "Basic"
}
resource "azurerm_network_interface" "nic01" {
  for_each = var.VMmap
  name                = "NIC-01-${each.value.vmname}"
  location            = var.location-info
  resource_group_name = local.rgname

  ip_configuration {
    name                          = "prodip"
    subnet_id                     = azurerm_subnet.Subnet01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.publicIP[each.key].id
  }
}
resource "azurerm_linux_virtual_machine" "prodLinux-VM" {
  for_each = var.VMmap
  name                  = each.value.vmname
  resource_group_name   = local.rgname
  location              = var.location-info
  size                  = each.value.size
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.nic01[each.key].id]
  depends_on = [ azurerm_public_ip.publicIP ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("${path.module}/key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7-LVM"
    version   = "latest"
  }
}


