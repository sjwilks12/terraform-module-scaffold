output "vpnGwPipAddress" {
  value = "${azurerm_public_ip.vpngw-pip.ip_address}"
}