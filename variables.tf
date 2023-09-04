variable "prefix" {
  default ="b13-ely"
}

variable "adminmail" {
  default = ["simplon.luna@gmail.com","laurent+alertes@lmathieu.com","joffreydupire@gmail.com"]
}

variable "resource_group_name" {
  description = "The name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "The Azure Region in which resources will be created"
  type        = string
}

variable "vnet_name" {
  description = "The name for the virtual network"
  type        = string
}

variable "address_space" {
  description = "The address space for the VNet"
  type        = list(string)
}

variable "subnet_name" {
  description = "The name for the subnet"
  type        = string
}

variable "subnet_address_prefixes" {
  description = "The address prefixes for the subnet"
  type        = list(string)
}

variable "aks_name" {
  description = "The name for the AKS cluster"
  type        = string
}

variable "node_pool_name" {
  description = "The name for the default node pool in AKS"
  type        = string
}

variable "node_count" {
  description = "The node count for the AKS cluster"
  type        = number
}

variable "vm_size" {
  description = "The VM size for the nodes in AKS cluster"
  type        = string
}

variable "use_nat_gateway" {
  description = "Boolean indicating whether to use NAT Gateway"
  type        = bool
  default     = false
}

variable "nat_gateway_name" {
  description = "The name of the NAT Gateway"
  type        = string
  default     = "myNATGateway"
}

variable "nginx_ingress_ip_name" {
  description = "The name of the public IP address resource for the NGINX Ingress."
  type        = string
  default     = "nginx-ingress-ip"
}

variable "nginx_ingress_ip_sku" {
  description = "The SKU for the public IP address of the NGINX Ingress. Can be Basic or Standard."
  type        = string
  default     = "Standard"
}

variable "route_table_name" {
  description = "The name of the Route Table"
  type        = string
  default     = "myRouteTable"
}

variable "next_hop_ip" {
  description = "The IP of the next hop (for example: a firewall or other device)"
  type        = string
  default     = ""  # By default, leave this blank, and enforce its value when calling the module.
}

