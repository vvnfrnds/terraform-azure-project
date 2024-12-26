# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

variable "prefix" {
  default = "tfvmex"
}

variable "subscription_id" {
  description = "Azure Subscription ID"  
}

variable "client_id" {
  description = "Azure Client ID(Application ID)"
}

variable "client_secret" {
  description = "Azure Client Secret"
  sensitive = true
}

variable "tenant_id" {
  description = "Tenant ID"
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources1"
  location = "EAST US"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                     = "example_pip"
  resource_group_name = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  allocation_method        = "Static"
  ddos_protection_mode = "VirtualNetworkInherited"
  idle_timeout_in_minutes = 4
  ip_version = "IPv4" 
  sku = "Standard" 
  sku_tier = "Regional"
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    name                 = "example_os_disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_password = "Password1234!"  # The password for the admin user
  disable_password_authentication = false  # Allows password authentication
}
