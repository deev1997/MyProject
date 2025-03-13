# network.tf

resource "azurerm_resource_group" "my-resource-group" {
  name     = "my-resource-group"
  location = "West Europe"
}

# Virtual network
resource "azurerm_virtual_network" "main" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "westeurope"
  resource_group_name = "my-resource-group"

  depends_on = [ azurerm_resource_group.my-resource-group ]

}

# Subnet
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = "my-resource-group"
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]

  depends_on = [ azurerm_resource_group.my-resource-group ]

}

# Public IP
resource "azurerm_public_ip" "vm_public_ip" {
  name                = "vm-public-ip"
  location            = "westeurope"
  resource_group_name = "my-resource-group"
  allocation_method   = "Dynamic"
  sku                 = "Basic"

  depends_on = [ azurerm_resource_group.my-resource-group ]

}

# Network security group (NSG) to allow SSH
resource "azurerm_network_security_group" "vm_nsg" {
  name                = "vm-nsg"
  location            = "westeurope"
  resource_group_name = "my-resource-group"

  depends_on = [ azurerm_resource_group.my-resource-group ]


  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network interface with public IP
resource "azurerm_network_interface" "main" {
  name                = "my-nic"
  location            = "westeurope"
  resource_group_name = "my-resource-group"


  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }

  depends_on = [
    azurerm_network_security_group.vm_nsg
  ]
}

# Associate NSG with the network interface
resource "azurerm_network_interface_security_group_association" "vm_nic_nsg" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id

  depends_on = [
    azurerm_network_interface.main,
    azurerm_network_security_group.vm_nsg,
  ]
}