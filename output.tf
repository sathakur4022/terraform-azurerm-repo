output "PUBIP" {
    value = [for intarnetIP in azurerm_network_interface.nic01 : intarnetIP.name]
  
}

output "uniqueVM2" {
    value = [for uniqueVM, intarnetIP in azurerm_network_interface.nic01 : uniqueVM]
  
}

output "PUBIP-map" {

    value = { for mapIP in azurerm_network_interface.nic01 : mapIP.name => mapIP.private_ip_address }
  
}

output "PUBIP-map2" {

    value = { for uniqueVM, mapIP in azurerm_network_interface.nic01 : uniqueVM => mapIP.private_ip_address }
  
}

output "PUBIP-key" {

    value = keys({ for uniqueVM, mapIP in azurerm_network_interface.nic01 : uniqueVM => mapIP.private_ip_address })
  
}

output "PUBIP-value" {

    value = values({ for uniqueVM, mapIP in azurerm_network_interface.nic01 : uniqueVM => mapIP.private_ip_address })
  
}