/*provider "azurerm" {
    features {}
}*/

resource "azurerm_resource_group" "core" {
   name         = "core"
   location     = "${var.loc}"
   tags         = "${var.tags}"
}

resource "azurerm_public_ip" "vpngw-pip" {
  name                = "vpnGatewayPublicIp"
  location            = "${azurerm_resource_group.core.location}"
  resource_group_name = "${azurerm_resource_group.core.name}"
  allocation_method   = "Dynamic"
  tags                = "${azurerm_resource_group.core.tags}"
}

resource "azurerm_virtual_network" "coreVnet" {
  name                = "core"
  location            = "${azurerm_resource_group.core.location}"
  resource_group_name = "${azurerm_resource_group.core.name}"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["1.1.1.1", "1.0.0.1"]

  subnet {
    name           = "GatewaySubnet"
    address_prefix = "10.0.0.0/24"
  }

  subnet {
    name           = "training"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "dev"
    address_prefix = "10.0.2.0/24"
  }

  tags           = "${azurerm_resource_group.core.tags}"
}

/* resource "azurerm_vpn_gateway" "example" {
  name                = "vpnGw"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  virtual_hub_id      = azurerm_virtual_hub.example.id
} *//*provider "azurerm" {
    features {}
}*/

resource "azurerm_resource_group" "nsgs" {
   name         = "NSGs"
   location     = "${var.loc}"
   tags         = "${var.tags}"
}

resource "azurerm_network_security_group" "resource_group_default" {
   name = "ResourceGroupDefault"
   resource_group_name  = "${azurerm_resource_group.nsgs.name}"
   location             = "${azurerm_resource_group.nsgs.location}"
   tags                 = "${azurerm_resource_group.nsgs.tags}"
}

resource "azurerm_network_security_rule" "AllowSSH" {
    name = "AllowSSH"
    resource_group_name         = "${azurerm_resource_group.nsgs.name}"
    network_security_group_name = "${azurerm_network_security_group.resource_group_default.name}"

    priority                    = 1010
    access                      = "Allow"
    direction                   = "Inbound"
    protocol                    = "Tcp"
    destination_port_range      = 22
    destination_address_prefix  = "*"
    source_port_range           = "*"
    source_address_prefix       = "*"
}

resource "azurerm_network_security_rule" "AllowHTTP" {
    name = "AllowHTTP"
    resource_group_name         = "${azurerm_resource_group.nsgs.name}"
    network_security_group_name = "${azurerm_network_security_group.resource_group_default.name}"

    priority                    = 1020
    access                      = "Allow"
    direction                   = "Inbound"
    protocol                    = "Tcp"
    destination_port_range      = 80
    destination_address_prefix  = "*"
    source_port_range           = "*"
    source_address_prefix       = "*"
}


resource "azurerm_network_security_rule" "AllowHTTPS" {
    name = "AllowHTTPS"
    resource_group_name         = "${azurerm_resource_group.nsgs.name}"
    network_security_group_name = "${azurerm_network_security_group.resource_group_default.name}"

    priority                    = 1021
    access                      = "Allow"
    direction                   = "Inbound"
    protocol                    = "Tcp"
    destination_port_range      = 443
    destination_address_prefix  = "*"
    source_port_range           = "*"
    source_address_prefix       = "*"
}

resource "azurerm_network_security_rule" "AllowSQLServer" {
    name = "AllowSQLServer"
    resource_group_name         = "${azurerm_resource_group.nsgs.name}"
    network_security_group_name = "${azurerm_network_security_group.resource_group_default.name}"

    priority                    = 1030
    access                      = "Allow"
    direction                   = "Inbound"
    protocol                    = "Tcp"
    destination_port_range      = 1443
    destination_address_prefix  = "*"
    source_port_range           = "*"
    source_address_prefix       = "*"
}

resource "azurerm_network_security_group" "nic_ubuntu" {
   name = "NIC_Ubuntu"
   resource_group_name  = "${azurerm_resource_group.nsgs.name}"
   location             = "${azurerm_resource_group.nsgs.location}"
   tags                 = "${azurerm_resource_group.nsgs.tags}"

    security_rule {
        name                       = "SSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = 22
        source_address_prefix      = "*"
        destination_address_prefix = "*"
  }
}