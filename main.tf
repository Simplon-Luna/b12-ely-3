resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  address_space       = "${var.address_space}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.subnet_name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefixes     = "${var.subnet_address_prefixes}"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.aks_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  dns_prefix          = "${var.aks_name}-dns"

  default_node_pool {
    name       = "${var.node_pool_name}"
    node_count = "${var.node_count}"
    vm_size    = "${var.vm_size}"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "dev"
  }
}

resource "azurerm_nat_gateway" "nat_gw" {
  count               = "${var.use_nat_gateway ? 1 : 0}"
  name                = "${var.nat_gateway_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  sku_name            = "Standard"
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat_gw_assoc" {
  count                = "${var.use_nat_gateway ? 1 : 0}"
  subnet_id            = "${azurerm_subnet.subnet.id}"
  nat_gateway_id       = "${azurerm_nat_gateway.nat_gw.*.id[0]}"
}

resource "azurerm_public_ip" "nginx_ingress_public_ip" {
  name                = "${var.nginx_ingress_ip_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  allocation_method   = "Static"
  sku                 = "${var.nginx_ingress_ip_sku}"
}

resource "azurerm_route_table" "rt" {
  name                = "${var.route_table_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  route {
    name                = "myRoute"
    address_prefix      = "0.0.0.0/0"
    next_hop_type       = "VirtualAppliance"
    next_hop_in_ip_address = var.next_hop_ip != "" ? var.next_hop_ip : azurerm_public_ip.nginx_ingress_public_ip.ip_address
  }
}

resource "azurerm_subnet_route_table_association" "subnet_rt_assoc" {
  subnet_id      = "${azurerm_subnet.subnet.id}"
  route_table_id = "${azurerm_route_table.rt.id}"
}
