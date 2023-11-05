provider "azurerm" {
  features {}
}
#creation groupe
resource "azurerm_resource_group" "groupeazure" {
  name     = "mygroupAzure"
  location = "eastus"
}

resource "azurerm_virtual_network" "networkazure" {
  name                = "myVNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.groupeazure.location
  resource_group_name = azurerm_resource_group.groupeazure.name
}

resource "azurerm_subnet" "subnetazure" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.groupeazure.name
  virtual_network_name = azurerm_virtual_network.networkazure.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.groupeazure.location
  resource_group_name = azurerm_resource_group.groupeazure.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "network_interface" {
  name                = "myNIC"
  location            = azurerm_resource_group.groupeazure.location
  resource_group_name = azurerm_resource_group.groupeazure.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.subnetazure.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "machinebilel" {
  name                = "VMbilel"
  location            = azurerm_resource_group.groupeazure.location
  resource_group_name = azurerm_resource_group.groupeazure.name

  network_interface_ids = [azurerm_network_interface.network_interface.id]

  size                 = "Standard_DS1_v2"
  admin_username       = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")  # Path to your public SSH key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

output "public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}