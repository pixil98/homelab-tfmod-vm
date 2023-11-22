terraform {
  required_version = ">= 1.3.6"
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.38.1"
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
