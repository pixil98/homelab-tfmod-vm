terraform {
  required_version = ">= 1.3.6"
  required_providers {
    null = {
      version = "3.2.1"
      configuration_aliases = [ "null" ]
    }
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.11"
      configuration_aliases = [ "proxmox" ]
    }
  }
}