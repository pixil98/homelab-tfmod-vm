terraform {
  required_version = ">= 1.3.6"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.67.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
  }
}
