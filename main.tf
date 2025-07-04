terraform {
  required_version = ">= 1.3.6"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.78.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }
  }
}
