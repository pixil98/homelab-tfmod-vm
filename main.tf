terraform {
  required_version = ">= 1.3.6"
  required_providers {
    proxmox = {
      source = "loeken/proxmox"
      version = "2.9.16"
    }
    null = {
      version = "3.2.2"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}
