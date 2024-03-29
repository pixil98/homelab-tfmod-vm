#---------------------------------------------------------------------------------------------------
# General
#---------------------------------------------------------------------------------------------------

variable "node" {
  description = "Proxmox node to host the virtual machine"
  type        = string
}

variable "namespace" {
  description = "Namespace to which the virtual machine belongs"
  type        = string
}

#---------------------------------------------------------------------------------------------------
# Virtual Machine
#---------------------------------------------------------------------------------------------------

variable "vm_name" {
  description = "Virtual machine hostname"
  type        = string
}

variable "vm_description" {
  description = "Virtual machine description"
  type        = string
  default     = ""
}

variable "vm_cpu_cores" {
  description = "Virtual machine core count"
  type        = number
  default     = 1
}

variable "vm_cpu_sockets" {
  description = "Virtual machine cpu socket count"
  type        = number
  default     = 1
}

variable "vm_memory" {
  description = "Virtual machine memory in megabytes"
  type        = number
  default     = 512
}

variable "vm_disk_size" {
  description = "Virtual machine disk size in gigabytes"
  type        = number
  default     = "1"
}

variable "vm_disk_class" {
  description = "Virtual machine disk classification"
  type        = string
}

variable "vm_network_address" {
  description = "Virtual machine IP address"
  type        = string
}

variable "vm_network_prefix" {
  description = "Virtual machine IP prefix length"
  type        = number
  default     = 20
}

variable "vm_network_gateway" {
  description = "Virtual machine network gateway"
  type        = string
  default     = "192.168.0.1"
}

variable "vm_network_nameserver" {
  description = "Virtual machine nameserver"
  type        = string
  default     = null
}

variable "vm_network_searchdomain" {
  description = "Virtual machine search domain"
  type        = string
  default     = null
}

variable "vm_user" {
  description = "Virtual machine username"
  type        = string
}

variable "vm_user_privatekey" {
  description = "Virtual machine user private key"
  type        = string
  sensitive   = true
  default     = null
}

#---------------------------------------------------------------------------------------------------
# Puppet
#---------------------------------------------------------------------------------------------------
variable "puppet_git_repo" {
  description = "Git repository for fetching Puppet roles. Only supports https."
  type        = string
  default     = "https://github.com/pixil98/homelab-puppet.git"
}

variable "puppet_git_ref" {
  description = "Git ref"
  type        = string
  default     = "production"
}

variable "puppet_role" {
  description = "Puppet role to assign to the virtual machine"
  type        = string
  default     = "base"
}
