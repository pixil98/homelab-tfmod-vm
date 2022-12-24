#---------------------------------------------------------------------------------------------------
# Proxmox
#---------------------------------------------------------------------------------------------------

variable "proxmox_host" {
  description = "Proxmox server hostname"
  type        = string
  default     = "hobbes.lab.reisman.org"
}

variable "proxmox_port" {
  description = "Proxmox server port"
  type        = number
  default     = 8006
}

variable "proxmox_user" {
  description = "Proxmox login username"
  type        = string
  sensitive   = true
}

variable "proxmox_password" {
  description = "Proxmox login password"
  type        = string
  sensitive   = true
}

#---------------------------------------------------------------------------------------------------
# Virtual Machine
#---------------------------------------------------------------------------------------------------

variable "vm_name" {
  description = "Virtual machine hostname"
  type        = string
}

variable "vm_namespace" {
  description = "Virtual machine namespace"
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
  description = "Virtual machine memory in Megabytes"
  type        = number
  default     = 512
}

variable "vm_disk_size" {
  description = "Virtual machine disk size"
  type        = string
  default     = "1G"
}

variable "vm_disk_class" {
  description = "Virtual machine disk classification"
  type        = string
  default     = "vmstorage"
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
  default     = "user"
  sensitive   = true
}

variable "vm_user_pubkey" {
  description = "Virtual machine user public key"
  type        = string
  sensitive   = true
}