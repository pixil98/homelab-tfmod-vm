terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.11"
    }
  }
}

provider "proxmox" {
  pm_api_url = format("https://%s:%d/api2/json", var.proxmox_host, var.proxmox_port)
  pm_parallel = 1
  pm_user = var.proxmox_user
  pm_password = var.proxmox_password
}